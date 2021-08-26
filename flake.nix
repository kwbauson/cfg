{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.inputs.utils.follows = "flake-utils";
    rnix-lsp.inputs.naersk.follows = "naersk";
    naersk.url = "github:nix-community/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.inputs.nixpkgs.follows = "nixpkgs";
    mach-nix.inputs.flake-utils.follows = "flake-utils";
    mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";
    pypi-deps-db.url = "github:DavHau/pypi-deps-db";
    pypi-deps-db.flake = false;
  };

  outputs =
    { self, nixos-hardware, ... }@inputs:
      with builtins; with inputs; with flake-utils.lib; with nixpkgs.lib;
      flake-utils.lib.eachSystem flake-utils.lib.allSystems
        (system: rec {
          packages = self.lib.pkgsForSystem
            {
              inherit system;
              isNixOS = false;
              host = "unknown";
            } // removeAttrs self.output-derivations [ "self-source" ];
        }) // rec {
        lib = builtins // rec {
          mylib = import ./mylib.nix nixpkgs;
          pkgsForSystem =
            { system, isNixOS, host }: import nixpkgs {
              inherit system;
              inherit (self) config;
              overlays = [
                (_: _: {
                  inherit isNixOS;
                  builtAsHost = host;
                })
              ] ++ self.overlays;
            };
          inherit (mylib) mapAttrValues import';
          nixosConfiguration = host: module: buildSystem {
            system = "x86_64-linux";
            modules = [
              { networking.hostName = host; }
              (callModule ./hosts/common.nix)
              (callModule module)
            ];
          };
          buildSystem = args: let system = nixosSystem args; in system.config.system.build.toplevel // system;
          callModule = module: { pkgs, config, ... }@args:
            (if isPath module then import module else module) (inputs // args);
          homeConfiguration = makeOverridable (
            { system ? "x86_64-linux"
            , pkgs ? pkgsForSystem { inherit system isNixOS host; }
            , username ? "keith"
            , homeDirectory ? "/home/${username}"
            , isNixOS ? true
            , isGraphical ? true
            , host ? "generic"
            }:
            let conf = (home-manager.lib.homeManagerConfiguration rec {
              inherit system pkgs username homeDirectory;
              configuration = {
                imports = [
                  { _module.args = { inherit self pkgs username homeDirectory isNixOS isGraphical host; }; }
                  ./home.nix
                ];
              };
            });
            in
            conf.activationPackage // conf // { inherit pkgs; }
          );
        };

        overlays = [
          (final: nixpkgs: {
            cfg = self;
            self-source = final.mylib.buildDirExcept ./.
              [ ".git" ".github" "output-paths" "secrets" ];
            inherit nixpkgs inputs;
            isNixOS = nixpkgs.isNixOS or false;
            neovim-master = neovim.defaultPackage.${nixpkgs.system};
          })
        ] ++ (import ./overlays.nix);
        config = import ./config.nix;

        nixConfBase = ''
          max-jobs = auto
          keep-going = true
          builders-use-substitutes = true
          extra-experimental-features = nix-command flakes
          fallback = true
          keep-env-derivations = true
          keep-outputs = true
        '';
        nixConf = ''
          ${nixConfBase}
          narinfo-cache-negative-ttl = 10
          extra-substituters = https://kwbauson.cachix.org
          extra-trusted-public-keys = kwbauson.cachix.org-1:a6RuFyeJKSShV8LAUw3Jx8z48luiCU755DkweAAkwX0=
        '';

        inherit (self.packages.x86_64-linux) programs-sqlite-path programs-sqlite;

        nixosConfigurations = with lib; mapAttrs
          (n: x: nixosConfiguration n x.configuration)
          (removeAttrs (import' ./hosts) [ "common" ]);

        homeConfigurations = mapAttrs (host: _: lib.homeConfiguration { inherit host; }) nixosConfigurations // {
          kwbauson = lib.homeConfiguration { host = "kwbauson"; isGraphical = false; };
          keith-mac = lib.homeConfiguration {
            isNixOS = false;
            system = "x86_64-darwin";
            username = "keithbauson";
            homeDirectory = "/Users/keithbauson";
            host = "keith-mac";
          };
        };

        mkChecks = pkgs: with pkgs; buildEnv {
          name = "checks";
          paths = flatten [
            saml2aws
            mysql57
            (nle.build {
              path = writeTextDir "requirements.txt" ''
                black
                bpython
                mypy
              '';
            })
            pynixify
          ];
        };

        checks = mkChecks self.packages.x86_64-linux;
        checks-mac = mkChecks self.packages.x86_64-darwin;

        inherit (self.packages.x86_64-linux) self-source;

        switch-scripts = mapAttrs (_: config: config.pkgs.switch) homeConfigurations;
        output-derivations = { inherit self-source; } // removeAttrs switch-scripts [ "keith-mac" ];
        output-paths = generators.toKeyValue { } (mapAttrs (n: v: toString v) output-derivations);

        iso = with self.packages.x86_64-linux; (nixos {
          imports = [ nixosModules.installer.cd-dvd.installation-cd-graphical-gnome ];
        }).config.system.build.isoImage;

        defaultPackage.x86_64-linux = self.packages.x86_64-linux.linkFarmFromDrvs "build"
          (attrValues output-derivations ++ [ checks ]);
        defaultPackage.x86_64-darwin = self.packages.x86_64-darwin.linkFarmFromDrvs "build"
          [ checks-mac keith-mac ];

        ci = output-derivations // { inherit checks; };
      };
}
