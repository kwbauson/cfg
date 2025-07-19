scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c38a64f87e605e2521f3796f31089d21ce2716ef";
    hash = "sha256-0LaGIHHOqN8KgUDrozRvyAHJdIu3Itj+5RjgqqFmDHA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
