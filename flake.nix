rec {
  nixConfig = {
    extra-substituters = [ "https://cache.kwbauson.com/" ];
    extra-trusted-public-keys = [ "cache.kwbauson.com:v9VWChI2sZUmlku8aRA9FLUA5OKKVc8IccCJ9flGU5s=" ];
  };
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.inputs.utils.follows = "flake-utils";
    rnix-lsp.inputs.naersk.follows = "naersk";
    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.inputs.nixpkgs.follows = "nixpkgs";
    mach-nix.inputs.flake-utils.follows = "flake-utils";
    mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";
    pypi-deps-db.url = "github:DavHau/pypi-deps-db";
    pypi-deps-db.flake = false;
    neovim.url = "github:neovim/neovim/nightly?dir=contrib";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    neovim.inputs.flake-utils.follows = "flake-utils";
  };

  outputs =
    { self, nixos-hardware, ... }@inputs: with builtins; with inputs; with nixpkgs.lib; flake-utils.lib.eachDefaultSystem
      (system: rec {
        packages = self.lib.pkgsForSystem {
          inherit system;
          isNixOS = false;
          host = "unknown";
        };
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
        buildSystem = args:
          let system = nixosSystem args; in
          system.config.system.build.toplevel.overrideAttrs (_: { passthru = system; });
        callModule = module: { pkgs, config, ... }@args:
          (if isPath module then import module else module) (inputs // args);
        homeConfiguration = makeOverridable (
          { system ? "x86_64-linux"
          , pkgs ? pkgsForSystem { inherit system isNixOS host; }
          , username ? "keith"
          , homeDirectory ? "/home/${username}"
          , isNixOS ? false
          , host ? "generic"
          , ...
          }@args:
          let conf = (home-manager.lib.homeManagerConfiguration rec {
            inherit system pkgs username homeDirectory;
            configuration = {
              imports = [
                { _module.args = { inherit pkgs username homeDirectory self; } // args; }
                ./home.nix
              ];
            };
          });
          in
          conf.activationPackage.overrideAttrs (_: { passthru = conf // { inherit pkgs; }; })
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

      nixConf = ''
        max-jobs = auto
        keep-going = true
        builders-use-substitutes = true
        extra-experimental-features = nix-command flakes ca-references ca-derivations
        extra-substituters = ${toString nixConfig.extra-substituters}
        extra-trusted-public-keys = ${toString nixConfig.extra-trusted-public-keys }
        keep-env-derivations = true
        keep-outputs = true
        narinfo-cache-negative-ttl = 10
      '';

      inherit (self.packages.x86_64-linux) programs-sqlite;

      nixosConfigurations = with lib; mapAttrs (n: x: nixosConfiguration n x.configuration) (import' ./hosts);

      homeConfigurations.graphical = lib.homeConfiguration { isNixOS = true; isGraphical = true; };
      homeConfigurations.non-graphical = lib.homeConfiguration {
        isNixOS = true;
        isGraphical = false;
      };

      homeConfigurations.keith-xps = homeConfigurations.graphical.override { host = "keith-xps"; };
      homeConfigurations.keith-desktop = homeConfigurations.graphical.override { host = "keith-desktop"; };
      homeConfigurations.keith-wsl = homeConfigurations.graphical.override { host = "keith-wsl"; isNixOS = false; };
      homeConfigurations.kwbauson = homeConfigurations.non-graphical.override { host = "kwbauson"; };
      homeConfigurations.keith-vm = homeConfigurations.graphical.override { host = "keith-vm"; };
      homeConfigurations.keith-mac = lib.homeConfiguration {
        isNixOS = false;
        isGraphical = true;
        system = "x86_64-darwin";
        username = "keithbauson";
        homeDirectory = "/Users/keithbauson";
        host = "keith-mac";
      };

      mkChecks = pkgs: with pkgs; buildEnv {
        name = "checks";
        paths = flatten [
          inlets
          juicefs
          saml2aws
          mysql57
          (nle.build {
            path = writeTextDir "requirements.txt" ''
              black==20.8b1
              bpython==0.20.1
              click==7.1.2
              ipdb==0.13.4
              mypy==0.790
              prospector[with_everything]==1.3.1
              pytest==6.1.2
              atlassian-python-api==3.4.1
            '';
          })
          pynixify
        ];
      };


      keith-xps = homeConfigurations.keith-xps.pkgs.switch;
      keith-desktop = homeConfigurations.keith-desktop.pkgs.switch;
      keith-wsl = homeConfigurations.keith-wsl.pkgs.switch;
      kwbauson = homeConfigurations.kwbauson.pkgs.switch;
      keith-vm = homeConfigurations.keith-vm.pkgs.switch;
      keith-mac = homeConfigurations.keith-mac.pkgs.switch;

      checks = mkChecks self.packages.x86_64-linux;
      checks-mac = mkChecks self.packages.x86_64-darwin;

      inherit (self.packages.x86_64-linux) self-source;

      outputs = { inherit self-source checks keith-xps keith-desktop kwbauson keith-vm; };
      output-paths = generators.toKeyValue { } (mapAttrs (n: v: toString v) outputs);

      iso = with self.packages.x86_64-linux; (nixos {
        imports = [ nixosModules.installer.cd-dvd.installation-cd-graphical-gnome ];
      }).config.system.build.isoImage;

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.linkFarmFromDrvs "build" (attrValues outputs);
      defaultPackage.x86_64-darwin = self.packages.x86_64-darwin.linkFarmFromDrvs "build" [ checks-mac keith-mac ];
    };
}
