let
  flake-compat = import (import ./nix/sources.nix).flake-compat;
  getFlake = builtins.getFlake or (src:
    (flake-compat { inherit src; }).defaultNix
  );
  cfg = getFlake (toString ./.);
in
cfg.packages.${builtins.currentSystem} // { inherit getFlake cfg; }
