scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b4e3c980ea22d51eec112de3dbf19c3683e143f0";
    hash = "sha256-rBRfGrox7fTBfLHL3RzdXPeXuEMnNQ6gMxlUA41n9kQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
