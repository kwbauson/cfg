[
  (final: prev: { scope-lib = import ../scope.nix { inherit (prev) lib; }; })
] ++ map import [
  ./misc.nix
  ./extraPackages.nix
  ./patched-packages.nix
  ./ci-checks.nix
]
