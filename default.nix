let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  flake-compat = with lock.nodes.flake-compat.locked; import (fetchTarball {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = narHash;
  });
  getFlake = path: (flake-compat { src = builtins.path { name = "source"; inherit path; }; }).defaultNix;
  cfg = getFlake ./.;
  pkgs = cfg.packages.${builtins.currentSystem};
in
{ inherit getFlake; } // pkgs.mylib // cfg.outputs // pkgs
