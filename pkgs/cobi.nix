scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "084cd8ca85ff98f811c246752d11924f699bbefb";
    hash = "sha256-OnEm2qTQ3MMsGeLHFSjzKNbHadOosoBDtESnijaTcCk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
