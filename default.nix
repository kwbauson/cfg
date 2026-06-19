with builtins;
{ system ? currentSystem }:
let
  fetchFlakeGit = src: fetchGit {
    url = src;
    # flake-compat doesn't handle root flakes with submodules
    submodules = (import (src + "/flake.nix")).inputs.self.submodules or false;
  };
  getSrc = src: if pathExists (src + "/.git") then fetchFlakeGit src else src;
  lock = fromJSON (readFile ./flake.lock);
  flake-compat = with lock.nodes.flake-compat.locked;
    import (fetchTarball { inherit url; sha256 = narHash; });
  getFlakeCompat = src: (flake-compat { src = getSrc src; }).defaultNix;
in
(getFlakeCompat ./.).packages.${system}.scope // { inherit getFlakeCompat; }
