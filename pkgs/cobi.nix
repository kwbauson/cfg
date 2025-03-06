scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9331b70c517363204bbb5f5d8c8aba9cb69850fb";
    hash = "sha256-ahWdrDQtM5cle+pXb8AQ56CzLdHSWVMPVu4+jo0Y8Lg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
