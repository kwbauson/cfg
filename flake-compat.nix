if builtins ? getFlake
then builtins.getFlake (toString ./.)
else (import (import ./nix/sources.nix).flake-compat { src = ./.; }).defaultNix
