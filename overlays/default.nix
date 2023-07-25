scope: with scope;
let overlays = importDir ./.; in
overlays // {
  default = composeManyExtensions [
    (final: prev: { scope-lib = import ../scope.nix { inherit (prev) lib; }; })
    overlays.misc
    overlays.extra-packages
    overlays.patched-packages
    overlays.ci-checks
  ];
}
