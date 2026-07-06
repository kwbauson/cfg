{
  inputs = {
    self.submodules = true;
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
    inherit (self.inputs.nixpkgs) lib;
    legacyPackages = self.lib.genAttrs (self.lib.attrNames self.inputs.nixpkgs.legacyPackages)
      (system: importNixpkgs { inherit system; });

    scope = import ./scope.nix self;
    packages = forAttrValues legacyPackages mkCustomPackages;

    nixosConfigurations = forAttrValuesFlagged machines "isNixOS" (machine:
      nixpkgs.lib.nixosSystem {
        specialArgs.scope = scope.${machine.system} // machine.scope;
        modules = [ modules.nixos ];
      });

    darwinConfigurations = forAttrValuesFlagged machines "isNixDarwin" (machine:
      nix-darwin.lib.darwinSystem {
        specialArgs.scope = scope.${machine.system} // machine.scope;
        modules = [ modules.nix-darwin ];
      });
  };
}
