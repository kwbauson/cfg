with builtins; let
  lock = fromJSON (readFile ./flake.lock);
  flake-compat = with lock.nodes.flake-compat.locked; import (fetchTarball {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = narHash;
  });
  getFlake = src:
    if builtins ? getFlake
    then builtins.getFlake (toString src)
    else (flake-compat { inherit src; }).defaultNix;
in
{ system ? currentSystem }:
(getFlake ./.).packages.${currentSystem}.scope // { inherit getFlake; }
