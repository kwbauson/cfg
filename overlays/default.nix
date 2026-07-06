{ _auto, scope }: with scope;
let overlays = importDir ./.; in
final: prev: {
  customPackages = final.extend (composeManyExtensions [
    (final: prev: { scope = root.scope (final // { inherit cfg; }); inherit scope'; })
    overlays.misc
    overlays.extra-packages
    overlays.ci-checks
    overlays.updates
  ]);
}
