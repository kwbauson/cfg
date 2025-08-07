scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "724781e4b8c8cc68f25a1605f8535f13e1a8a810";
    hash = "sha256-G1V82ZPdeCoaNN/EC0p+BK/QUlhiDD4z21F66M1kCH4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
