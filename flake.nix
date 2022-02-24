{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
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
    { self, nixpkgs-unstable, nixos-hardware, ... }@inputs:
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
          extraOverlays =
            if pathExists ./extra-overlays
            then mapAttrsToList (file: _: import (./extra-overlays + "/${file}")) (readDir ./extra-overlays)
            else [ ];
          pkgsForSystem =
            { system, isNixOS, host }: import (if hasSuffix "-linux" system then nixpkgs else nixpkgs-unstable) {
              inherit system;
              inherit (self) config;
              overlays = [
                (_: _: {
                  inherit isNixOS;
                  builtAsHost = host;
                })
              ] ++ self.overlays ++ extraOverlays;
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
                  ({ lib, ... }: { _module.args = { inherit self username homeDirectory isNixOS isGraphical host; } // { pkgs = lib.mkForce pkgs; }; })
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
            inherit nixpkgs inputs self-source;
            isNixOS = nixpkgs.isNixOS or false;
            neovim-master = neovim.defaultPackage.${nixpkgs.system};
          })
        ] ++ (import ./overlays.nix);
        config = import ./config.nix;

        nixConfBase = ''
          max-jobs = auto
          keep-going = true
          builders-use-substitutes = true
          extra-experimental-features = nix-command flakes recursive-nix
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

        self-source = builtins.path {
          path = ./.;
          name = "source";
          filter = path: type: !builtins.any (p: p == (baseNameOf path))
            [ ".git" ".github" "output-paths" "secrets" ];
        };

        switch-scripts = mapAttrs (_: config: config.pkgs.switch) homeConfigurations;
        output-derivations = { inherit self-source; } // removeAttrs switch-scripts [ "keith-mac" ];
        output-paths = generators.toKeyValue { } (mapAttrs (n: v: toString v) output-derivations);

        iso = with self.packages.x86_64-linux; (nixos {
          imports = [ nixosModules.installer.cd-dvd.installation-cd-graphical-gnome ];
        }).config.system.build.isoImage;

        defaultPackage.x86_64-linux = self.packages.x86_64-linux.linkFarmFromDrvs "build" (attrValues ci);
        defaultPackage.x86_64-darwin = self.packages.x86_64-darwin.linkFarmFromDrvs "build"
          [ self.packages.x86_64-darwin.checks keith-mac ];

        ci = removeAttrs output-derivations [ "self-source" ] // { inherit (self.packages.x86_64-linux) checks; };
      };
}
