{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.inputs.utils.follows = "flake-utils";
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
    }: flake-utils.lib.eachDefaultSystem (system: rec {

      packages = import nixpkgs {
        inherit system;
        config = import ./config.nix;
        overlays = [ (_: _: { cfg = self; }) ] ++ (import ./overlays.nix);
      };

    }) // rec {
      lib = {
        nixosConfiguration = hostname: (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = let module = import (./configurations + "/${hostname}/configuration.nix"); in
            [ ({ pkgs, config, ... }@args: module (self.inputs // args)) ];
        }) // { drv = (lib.nixosConfiguration hostname).config.system.build.toplevel; };
        homeConfiguration =
          { system ? "x86_64-linux"
          , pkgs ? self.packages.${system}
          , username ? "keith"
          , homeDirectory ? "/home/${username}"
          , ...
          }@args: (home-manager.lib.homeManagerConfiguration rec {
            configuration = import ./home.nix ({
              inherit pkgs username homeDirectory;
              config = configuration;
            } // args);
            inherit system pkgs username homeDirectory;
          }).activationPackage;
      };

      nixosConfigurations.keith-xps = lib.nixosConfiguration "keith-xps";
      nixosConfigurations.kwbauson = lib.nixosConfiguration "kwbauson";
      nixosConfigurations.keith-vm = lib.nixosConfiguration "keith-vm";

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

      build-cfg-image = with self.packages.x86_64-linux; dockerTools.buildLayeredImage {
        name = "kwbauson/build-cfg";
        tag = "latest";
        contents = [
          dockerTools.binSh
          "${nixosConfigurations.keith-xps.drv}/sw"
          "${nixosConfigurations.kwbauson.drv}/sw"
          "${nixosConfigurations.keith-vm.drv}/sw"
          # "${homeConfigurations.graphical}/home-path"
          "${homeConfigurations.non-graphical}/home-path"
        ];
      };
    };
}
