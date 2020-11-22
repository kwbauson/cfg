let
  sources = import ./nix/sources.nix;
  cfg = (import sources.flake-compat { src = ./.; }).defaultNix;
in
cfg.packages.${builtins.currentSystem}
