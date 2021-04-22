let
  getFlake = src:
    (import (import ./nix/sources.nix).flake-compat { src = ./.; }).defaultNix;
in
(getFlake ./.).packages.${builtins.currentSystem}
