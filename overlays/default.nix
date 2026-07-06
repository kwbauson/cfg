{ _auto, scope }: with scope;
let overlays = importDir ./.; in
composeManyExtensions [
  (final: prev: { scope = root.scope (final // { inherit cfg; }); })
  (final: prev: { inherit scope'; })
  overlays.misc
  overlays.extra-packages
  overlays.ci-checks
  overlays.updates
]
