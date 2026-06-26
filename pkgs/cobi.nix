scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b98b9899eba201eefe609bf8e82a02fbe78583d9";
    hash = "sha256-gnyV5HmnOvYWWFX6hkJPNa+bfnEkx+ElWNlonDGImCQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
