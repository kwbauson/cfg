let
  getFlake = src:
    if builtins ? getFlake
    then builtins.getFlake (toString src)
    else (import (import ./nix/sources.nix).flake-compat { src = ./.; }).defaultNix;
in
(getFlake ./.).packages.${builtins.currentSystem}
