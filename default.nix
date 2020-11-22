(import (import ./nix/sources.nix).flake-compat { src = ./.; }).defaultNix.packages.${builtins.currentSystem}
