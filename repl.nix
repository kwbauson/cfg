let pkgs = import ./.;
in pkgs.mylib // pkgs // builtins.getFlake (toString ./.)
