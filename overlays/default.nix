[
  (final: prev: { scope-lib = import ../scope.nix { inherit (prev) lib; }; })
] ++ map import [
  ./misc.nix
  ./extra-packages.nix
  ./patched-packages.nix
  ./aliases.nix
  ./ci-checks.nix
]
