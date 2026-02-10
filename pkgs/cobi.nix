scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-02-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ddb75ca92d5fe42d7c94e0fd34bc82ac79dada84";
    hash = "sha256-kn4EPI+NsJDbmEMSEdQv42QNAdMBk+b7OgeDI/Dw4wQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
