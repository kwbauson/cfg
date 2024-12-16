with builtins;
{ system ? currentSystem, forceFlakeCompat ? false }:
let
  lock = fromJSON (readFile ./flake.lock);
  flake-compat = with lock.nodes.flake-compat.locked; import (fetchTarball {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = narHash;
  });
  compatGetFlake = src: (flake-compat { inherit src; }).defaultNix;
  getFlake = src:
    if builtins ? getFlake && !forceFlakeCompat
    then builtins.getFlake (toString src)
    else compatGetFlake src;
in
(getFlake ./.).packages.${system}.scope // { inherit getFlake; }
