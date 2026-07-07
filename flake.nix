{
  inputs = {
    self.submodules = true;
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    nixpkgs-lib.url = ./nixpkgs/lib;
    nixpkgs-lib.inputs.root.follows = "";
    flake-compat.url = "https://github.com/NixOS/flake-compat/archive/master.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-lib";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-lib";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs-lib";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-lib";
  };
  outputs = { self, ... }: with self.scope; {
    inherit (self.inputs.nixpkgs) lib;
    legacyPackages = self.lib.mapAttrs (system: _: importNixpkgs { inherit system; }) self.inputs.nixpkgs.legacyPackages;

    scope = import ./scope.nix self;
    packages = forAttrNames legacyPackages root.pkgs;

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
