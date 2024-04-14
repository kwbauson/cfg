{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat.url = "github:edolstra/flake-compat";
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
        (final: prev:
          if system == "aarch64-darwin"
          then { lib = prev.lib.extend (finallib: prevlib: { mdDoc = prevlib.id; }); }
          else { }
        )
      ];
    });
    overlays = import ./overlays scope;
    nixosModules = modules;
    checks = forAttrValues packages (getAttr "checks");

    nixosConfigurations = forAttrNamesHaving machines "configuration" (machine-name:
      nixpkgs.lib.nixosSystem rec {
        pkgs = packages.${machines.${machine-name}.system or "x86_64-linux"};
        specialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ nixosModules.nixos ];
      });

    darwinConfigurations = forAttrNamesHaving machines "darwin-configuration" (machine-name:
      nix-darwin.lib.darwinSystem rec {
        pkgs = packages.${machines.${machine-name}.system or "aarch64-darwin"};
        specialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ nixosModules.nix-darwin ];
      });

    homeConfigurations = forAttrNames machines (machine-name:
      home-manager.lib.homeManagerConfiguration rec {
        pkgs = packages.${machines.${machine-name}.system or "x86_64-linux"};
        extraSpecialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ nixosModules.home-manager ];
      });
  };
}
