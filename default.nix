with builtins;
{ system ? currentSystem, forceFlakeCompat ? false }:
let
  lock = fromJSON (readFile ./flake.lock);
  flake-compat = with lock.nodes.flake-compat.locked;
    import (fetchTarball { inherit url; sha256 = narHash; });
  getFlake = src:
    if builtins ? getFlake && !forceFlakeCompat
    then builtins.getFlake (toString src)
    else (flake-compat { inherit src; copySourceTreeToStore = false; }).defaultNix;
in
(getFlake ./.).packages.${system}.scope // { inherit getFlake; }
