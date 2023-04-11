{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable-small";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "flake-utils";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-utils.flake = true;
    flake-utils.inputs.systems.follows = "systems";
    systems.url = "github:nix-systems/default";
    nixos-hardware.flake = true;
  };
  outputs = { self, ... }: with self.scope; {
    scope = import ./scope.nix { inherit (self.inputs.nixpkgs) lib; flake = self; };
    inherit (importDir ./.) overlays modules machines constants;

    packages = genAttrs platforms.all (system: import nixpkgs {
      inherit system;
      config = import ./config.nix;
      overlays = [
        (final: prev: { scope = import ./scope.nix (final // { inherit flake; }); })
        overlays.aliases
        overlays.ci-checks
      ] ++ overlays.misc;
    });

    nixosConfigurations = forAttrNamesHaving machines "configuration" (machine-name:
      nixpkgs.lib.nixosSystem rec {
        pkgs = packages.${machines.${machine-name}.system or "x86_64-linux"};
        specialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ scope.modules.common.configuration ];
      });

    darwinConfigurations = forAttrNamesHaving machines "darwin-configuration" (machine-name:
      nix-darwin.lib.darwinSystem rec {
        pkgs = packages.${machines.${machine-name}.system or "aarch64-darwin"};
        specialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ scope.modules.common.darwin-configuration ];
      });

    homeConfigurations = forAttrNames machines (machine-name:
      home-manager.lib.homeManagerConfiguration rec {
        pkgs = packages.${machines.${machine-name}.system or "x86_64-linux"};
        extraSpecialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ scope.modules.common.home ];
      });

    nixConfBase = ''
      max-jobs = auto
      keep-going = true
      extra-experimental-features = nix-command flakes recursive-nix
      fallback = true
    '';
    nixConf = ''
      ${nixConfBase}
      narinfo-cache-negative-ttl = 10
      extra-substituters = https://kwbauson.cachix.org
      extra-trusted-public-keys = kwbauson.cachix.org-1:a6RuFyeJKSShV8LAUw3Jx8z48luiCU755DkweAAkwX0=
    '';
  };
}
