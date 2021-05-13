let pkgs = import ./.;
in pkgs.mylib // pkgs // pkgs.cfg
