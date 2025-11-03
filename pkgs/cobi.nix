scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0603f91523981a824900dd7e2dd50430a587dc67";
    hash = "sha256-fgIU99Ks1dSKQ4jAHgT/amC3Ou7Sp/W6dDoO+SGGrP4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
