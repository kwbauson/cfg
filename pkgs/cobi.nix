scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "11d780d87a22fe6c2734ee6da7a4fcfaf3f90508";
    hash = "sha256-Iyd/5sCUt/DZbzue8xrRGmKmSTVsj7MQu2XcOnLJK5E=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
