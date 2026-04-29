{ _auto, scope }: with scope;
let overlays = importDir ./.; in
composeManyExtensions [
  (final: prev: { inherit scope'; })
  overlays.misc
  overlays.extra-packages
  overlays.patched-packages
  overlays.ci-checks
  overlays.python
  overlays.updates
]
