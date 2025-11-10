scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b9c6c02de619e292367b5d7233f8429ab98e26b9";
    hash = "sha256-YoTFxmG0XkNh8ZItiU/5Iz7ci4EASCpdLMBi42k9TuY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
