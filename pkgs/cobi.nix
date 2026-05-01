scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "59882e0636b7155aabcb567895900614a45f1be3";
    hash = "sha256-Ih4MwJXhg6ge20BS1Kd7ek3F5s2rMfteK6a7yJ3JL2I=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
