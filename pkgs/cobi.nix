scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ddda5b02ff3b770ef8980f8cf6f4f60ba8fe2559";
    hash = "sha256-LDEgEIGYyjRwHpB9TYT2AFNfF72xSXoWC6FUz+ylR9o=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
