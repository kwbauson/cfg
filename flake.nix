{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.inputs.utils.follows = "flake-utils";
    rnix-lsp.inputs.naersk.follows = "naersk";
    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:DavHau/mach-nix";
    mach-nix.inputs.nixpkgs.follows = "nixpkgs";
    mach-nix.inputs.flake-utils.follows = "flake-utils";
    mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";
    pypi-deps-db.url = "github:DavHau/pypi-deps-db";
    pypi-deps-db.flake = false;
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , home-manager
    , ...
    }@inputs: flake-utils.lib.eachDefaultSystem (system: rec {
      packages = import nixpkgs {
        inherit system;
        inherit (self) overlays config;
      };
    }) // rec {
      lib = with builtins; with nixpkgs.lib; rec {
        mylib = import ./mylib.nix nixpkgs;
        inherit (mylib) mapAttrValues importDir;
        nixosConfiguration = module: buildSystem { system = "x86_64-linux"; modules = [ (callModule module) ]; };
        buildSystem = args:
          let system = nixosSystem args;
          in
          system.config.system.build.toplevel // system // {
            paths = filter (x: x.allowSubstitutes or true) system.config.environment.systemPackages;
          };
        callModule =
          module: { pkgs, config, ... }@args: (if isPath module then import module else module) (inputs // args);
        homeConfiguration = makeOverridable (
          { system ? "x86_64-linux"
          , pkgs ? import nixpkgs {
              inherit system;
              inherit (self) config;
              overlays = self.overlays ++ [ (_: _: { inherit isNixOS; }) ];
            }
          , username ? "keith"
          , homeDirectory ? "/home/${username}"
          , isNixOS ? false
          , ...
          }@args:
          let conf = (home-manager.lib.homeManagerConfiguration rec {
            configuration = import ./home.nix ({
              inherit pkgs username homeDirectory;
              config = configuration;
            } // args // { inherit self; });
            inherit system pkgs username homeDirectory;
          });
          in
          conf.activationPackage // conf // {
            paths = filter (x: x.allowSubstitutes or true) conf.config.home.packages;
          }
        );
      };

      overlays = [
        (_: nixpkgs: {
          cfg = self;
          mylib = import ./mylib.nix nixpkgs;
          inherit nixpkgs;
        })
      ] ++ (import ./overlays.nix);
      config = import ./config.nix;

      inherit (self.packages.x86_64-linux) programs-sqlite;

      nixosConfigurations = with lib; mapAttrValues nixosConfiguration (importDir ./hosts);

      homeConfigurations.graphical = lib.homeConfiguration { isNixOS = true; isGraphical = true; };
      homeConfigurations.non-graphical = lib.homeConfiguration {
        isNixOS = true;
        isGraphical = false;
        isServer = true;
      };

      homeConfigurations.keith-xps = homeConfigurations.graphical.override { host = "keith-xps"; };
      homeConfigurations.keith-desktop = homeConfigurations.graphical.override { host = "keith-desktop"; };
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
        paths = [
          inlets
          juicefs
          saml2aws
          mysql57
          (nle {
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
        ];
      };

      checks = self.mkChecks self.packages.x86_64-linux;
      checks-mac = self.mkChecks self.packages.x86_64-darwin;
    };
}
