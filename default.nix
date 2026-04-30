with builtins;
{ system ? currentSystem }:
let
  lock = fromJSON (readFile ./flake.lock);
  flake-compat = with lock.nodes.flake-compat.locked;
    import (fetchTarball { inherit url; sha256 = narHash; });
  getFlakeCompat = src: (flake-compat { inherit src; useBuiltinsFetchTree = true; }).defaultNix;
in
(getFlakeCompat ./.).packages.${system}.scope // { inherit getFlakeCompat; }
