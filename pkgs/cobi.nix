scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "31302e66de01234e3154c296cda81817a3648dba";
    hash = "sha256-HiulkSQvh2mHq/dN+/4yFKD9k9PeA4PdORDOPB5YSMs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
