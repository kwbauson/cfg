{
  inputs = {
    nixpkgs-lib.url = ./pkgs/nixpkgs-lib;
    nixpkgs-lib.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    flake-compat.url = "https://github.com/NixOS/flake-compat/archive/master.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-lib";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-lib";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs-lib";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, ... }: with self.scope; {
    scope = import ./scope.nix { inherit (self.inputs.nixpkgs) lib; flake = self; };

    packages = genAttrs systems.flakeExposed (system: import nixpkgs {
      inherit system;
      config = root.config;
      overlays = [
        (final: prev: { scope = root.scope (final // { inherit flake; }); })
        root.overlays
      ];
    });

    nixosConfigurations = forAttrValuesFlagged machines "isNixOS" (machine:
      nixpkgs.lib.nixosSystem {
        specialArgs.scope = packages.${machine.system}.scope // machine.scope;
        modules = [ modules.nixos ];
      });

    darwinConfigurations = forAttrValuesFlagged machines "isNixDarwin" (machine:
      nix-darwin.lib.darwinSystem {
        specialArgs.scope = packages.${machine.system}.scope // machine.scope;
        modules = [ modules.nix-darwin ];
      });
  };
}
