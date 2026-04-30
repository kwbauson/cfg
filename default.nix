with builtins;
{ system ? currentSystem }:
let
  lock = fromJSON (readFile ./flake.lock);
  flake-compat = with lock.nodes.flake-compat.locked;
    import (fetchTarball { inherit url; sha256 = narHash; });
  getFlakeCompat = src: (flake-compat {
    # do own copying to store since lix flake-compat doesn't fetchGit shallow clones
    # see https://github.com/NixOS/flake-compat/pull/75
    src = if builtins ? fetchGit && pathExists (src + "/.git") then fetchGit src else src;
    copySourceTreeToStore = false;
    useBuiltinsFetchTree = true;
  }).defaultNix;
in
(getFlakeCompat ./.).packages.${system}.scope // { inherit getFlakeCompat; }
