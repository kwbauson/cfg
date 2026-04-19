{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat.url = "git+https://git.lix.systems/lix-project/flake-compat";
    flake-compat.flake = false;
    nixos-hardware.flake = true;
  };
  outputs = { self, ... }: with self.scope; {
    scope = import ./scope.nix { inherit (self.inputs.nixpkgs) lib; flake = self; };

    packages = genAttrs systems.flakeExposed (system: import nixpkgs {
      inherit system;
      config = import ./config.nix;
      overlays = [
        (final: prev: { scope = import ./scope.nix (final // { inherit flake; }); })
        overlays.default
      ];
    });
    overlays = import ./overlays scope;
    nixosModules = modules;

    nixosConfigurations = forAttrValuesFlagged machines "isNixOS" (machine:
      nixpkgs.lib.nixosSystem {
        specialArgs.scope = packages.${machine.system}.scope // machine.scope;
        modules = [ nixosModules.nixos ];
      });

    darwinConfigurations = forAttrValuesFlagged machines "isNixDarwin" (machine:
      nix-darwin.lib.darwinSystem {
        specialArgs.scope = packages.${machine.system}.scope // machine.scope;
        modules = [ nixosModules.nix-darwin ];
      });
  };
}
