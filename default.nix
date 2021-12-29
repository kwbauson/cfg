let
  flake-compat = import (import ./nix/sources.nix).flake-compat;
  getFlake = path: (flake-compat { src = builtins.path { name = "source"; inherit path; }; }).defaultNix;
  cfg = getFlake ./.;
  pkgs = cfg.packages.${builtins.currentSystem};
in
pkgs.mylib // cfg.outputs // pkgs
