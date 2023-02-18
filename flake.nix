{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "flake-utils";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-utils.flake = true;
    nixos-hardware.flake = true;
  };
  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }: with self.scope; {
    scope = import ./scope.nix { inherit (nixpkgs) lib; flake = self; };
    inherit (importDir ./.) overlays modules machines;

    packages = genAttrs platforms.all (system: import nixpkgs {
      inherit system;
      config = import ./config.nix;
      overlays = [
        (final: prev: { scope = import ./scope.nix (final // { inherit flake; }); })
        overlays.ci-checks
      ];
    });

    nixosConfigurations = forAttrNamesHaving machines "configuration" (machine-name:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit machine-name;
          pkgs = packages.x86_64-linux;
          inherit (packages.x86_64-linux) scope;
        };
        modules = [ modules.common.configuration ];
      });

    darwinConfigurations = forAttrNamesHaving machines "darwin-configuration" (machine-name:
      nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit machine-name;
          pkgs = packages.aarch64-darwin;
          inherit (packages.aarch64-darwin) scope;
        };
        modules = [ modules.common.darwin-configuration ];
      });

    homeConfigurations = forAttrNames machines (machine-name:
      home-manager.lib.homeManagerConfiguration rec {
        pkgs = packages.x86_64-linux;
        extraSpecialArgs = {
          inherit machine-name pkgs;
          inherit (pkgs) scope;
        };
        modules = [ modules.common.home ];
      });
  };
}
