{ _overlay, scope }: with scope;
rustPlatform.buildRustPackage (finalAttrs: {
  inherit (prev) pname;
  # this newer version does multi-monitor, latest doesn't read config
  version = "0.3.0";
  src = prev.src.override {
    tag = finalAttrs.version;
    hash = "sha256-VnzIPHlO6KX7qpxqJH8jXS43uBcKkkZcdlR5idpuzJ0=";
  };
  cargoLock.lockFile = "${finalAttrs.src}/Cargo.lock";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];
  buildInputs = [ gtk4 gtk4-layer-shell ];
})
