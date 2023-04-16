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
    inherit (importDir ./.) overlays modules machines constants;

    packages = genAttrs systems.flakeExposed (system: import nixpkgs {
      inherit system;
      config = import ./config.nix;
      overlays = [
        (final: prev: { scope = import ./scope.nix (final // { inherit flake; }); })
      ] ++ overlays;
    });

    nixosConfigurations = forAttrNamesHaving machines "configuration" (machine-name:
      nixpkgs.lib.nixosSystem rec {
        pkgs = packages.${machines.${machine-name}.system or "x86_64-linux"};
        specialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ scope.modules.nixos ];
      });

    darwinConfigurations = forAttrNamesHaving machines "darwin-configuration" (machine-name:
      nix-darwin.lib.darwinSystem rec {
        pkgs = packages.${machines.${machine-name}.system or "aarch64-darwin"};
        specialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ scope.modules.nix-darwin ];
      });

    homeConfigurations = forAttrNames machines (machine-name:
      home-manager.lib.homeManagerConfiguration rec {
        pkgs = packages.${machines.${machine-name}.system or "x86_64-linux"};
        extraSpecialArgs = { inherit (pkgs) scope; inherit machine-name; };
        modules = [ scope.modules.home-manager ];
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
