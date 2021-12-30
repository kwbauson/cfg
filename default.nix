let
  flake-compat = import (import ./nix/sources.nix).flake-compat;
  getFlake = path:
    if builtins ? getFlake
    then builtins.getFlake (toString path)
    else (flake-compat { src = builtins.path { name = "source"; inherit path; }; }).defaultNix;
  cfg = getFlake ./.;
  pkgs = cfg.packages.${builtins.currentSystem};
in
{ inherit getFlake; } // pkgs.mylib // cfg.outputs // pkgs
