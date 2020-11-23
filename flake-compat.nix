(import (import ./nix/sources.nix).flake-compat { src = builtins.path { name = "source"; path = ./.; }; }).defaultNix
