{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    rnix-lsp.inputs.nixpkgs.follows = "nixpkgs";
    rnix-lsp.inputs.utils.follows = "flake-utils";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:DavHau/mach-nix";
    mach-nix.inputs.nixpkgs.follows = "nixpkgs";
    mach-nix.inputs.flake-utils.follows = "flake-utils";
    mach-nix.inputs.pypi-deps-db.follows = "pypi-deps-db";
    pypi-deps-db.url = "github:DavHau/pypi-deps-db";
    pypi-deps-db.flake = false;
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    }: flake-utils.lib.eachDefaultSystem (system: rec {

      packages = import nixpkgs {
        inherit system;
        config = import ./config.nix;
        overlays = [ (_: _: { cfg = self; }) ] ++ (import ./overlays.nix);
      };

      inherit (packages) defaultPackage;

    });
}
