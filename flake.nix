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
    pypi-deps-db.url = "github:DavHau/pypi-deps-db?rev=4893bcc959a4e9f3b8c2e1a6c3f254c987552ff0";
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
          in
          conf.activationPackage // conf // {
            paths = filter (x: x.allowSubstitutes or true) conf.config.home.packages;
          };
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
