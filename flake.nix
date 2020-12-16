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
        mapSubDirs = f: path: mapAttrs (n: v: f n) (filterAttrs (v: n: n == "directory") (readDir path));
        callModule = path: { pkgs, config, ... }@args: import path (inputs // args);
        buildSystem = args: (system: system.config.system.build.toplevel // system) (nixpkgs.lib.nixosSystem args);
        nixosConfiguration = hostname: buildSystem {
          system = "x86_64-linux";
          modules = [ (callModule (./configurations + "/${hostname}/configuration.nix")) ];
        };
        homeConfiguration =
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
          in conf.activationPackage // conf;
      };

      overlays = [
        (final: prev: { cfg = self; mylib = import ./mylib.nix final prev; })
      ] ++ (import ./overlays.nix);
      config = import ./config.nix;

      inherit (self.packages.x86_64-linux) programs-sqlite;

      nixosConfigurations = lib.mapSubDirs lib.nixosConfiguration ./configurations;

      homeConfigurations.graphical = lib.homeConfiguration { isNixOS = true; isGraphical = true; };
      homeConfigurations.non-graphical = lib.homeConfiguration { isNixOS = true; isGraphical = false; };

      homeConfigurations.keith-xps = homeConfigurations.graphical;
      homeConfigurations.kwbauson = homeConfigurations.non-graphical;
      homeConfigurations.keith-vm = homeConfigurations.graphical;
      homeConfigurations.keith-mac = lib.homeConfiguration {
        isNixOS = false;
        isGraphical = true;
        system = "x86_64-darwin";
        username = "keithbauson";
        homeDirectory = "/Users/keithbauson";
      };
    };
}
