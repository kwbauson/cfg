scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "bad03ef2173e850c84881a0e3686c72740f20707";
    hash = "sha256-n5jbu2bafLH4dcbwbRtZQSo+YvOEerviBSE8Wp3YgzE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
