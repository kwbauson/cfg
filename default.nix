with builtins;
{ system ? currentSystem }:
let
  lock = fromJSON (readFile ./flake.lock);
  flake-compat = with lock.nodes.flake-compat.locked;
    import (fetchTarball { inherit url; sha256 = narHash; });
  getFlake = src:
    if builtins ? getFlake
    then builtins.getFlake (toString src)
    else (flake-compat { inherit src; copySourceTreeToStore = false; }).defaultNix;
in
(getFlake ./.).packages.${system}.scope // { inherit getFlake; }
