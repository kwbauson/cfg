scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "540d8acacefc2285541769740ec92c330618dae0";
    hash = "sha256-cQL1NXNhJNv20ucXia/YnSKXAJ0GhfcsQx2jdSq18Gc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
