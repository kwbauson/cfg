let
  flake-compat = import (import ./nix/sources.nix).flake-compat;
  getFlake = builtins.getFlake or (src:
    (flake-compat { inherit src; }).defaultNix
  );
  cfg = getFlake (builtins.path { name = "source"; path = ./.; });
in
cfg.packages.${builtins.currentSystem} // { inherit getFlake cfg; }
