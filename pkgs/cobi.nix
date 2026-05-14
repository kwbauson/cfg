scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9ae302a071a76769aacf9403ab3516193a09879b";
    hash = "sha256-tsh+kUuROivsXamomd810Q3qxrKmNm/JyXFvuZ7EjVI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
