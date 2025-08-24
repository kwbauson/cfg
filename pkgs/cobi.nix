scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-23";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "cee71987b9077250988211800d72d104ac40b095";
    hash = "sha256-5G0FROX68iEZWnRL2UfhjIByUZx6Jg29hZCYWHS4oMo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
