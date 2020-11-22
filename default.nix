let pkgs = (import ./flake-compat.nix).packages.${builtins.currentSystem};
in pkgs.mylib // pkgs
