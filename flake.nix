{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , home-manager
    , ...
    }: flake-utils.lib.eachDefaultSystem (system: rec {

      packages = import nixpkgs {
        inherit system;
        config = import ./config.nix;
        overlays = [ (_: _: { cfg = self; }) ] ++ (import ./overlays.nix);
      };

      defaultPackage = packages.homeManagerConfiguration.activationPackage;

    });
}
