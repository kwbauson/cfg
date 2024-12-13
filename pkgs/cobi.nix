scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "da28259a9a67b4330d77e8959a17618301897d9a";
    hash = "sha256-5KeY8K4xlWS92ztkvoXsBkaFpSTfI5bjb91wLkag2sU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
