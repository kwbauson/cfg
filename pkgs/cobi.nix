scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "54d02f174105649bf3c8ca16e5c0c328f33bc4c5";
    hash = "sha256-/DLzXVtpcj9lfDHkGTNO9qTQfpixAZWlo0r1EabCDdg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
