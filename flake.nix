{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    nixpkgs-lib.url = ./pkgs/nixpkgs-lib;
    nixpkgs-lib.inputs.cfg.follows = "";
    flake-compat.url = "https://github.com/NixOS/flake-compat/archive/master.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-lib";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-lib";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs-lib";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, ... }: with self.scope; {
    scope = import ./scope.nix { inherit (self.inputs.nixpkgs) lib; cfg = self; };

    packages = genAttrs systems.flakeExposed (system: import nixpkgs {
      inherit system;
      config = root.config;
      overlays = [
        (final: prev: { scope = root.scope (final // { inherit cfg; }); })
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
