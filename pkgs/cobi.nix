scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8445a4dc1e5051570cf41e18fb8459b70b9bd7aa";
    hash = "sha256-/Tsh9YANadbU7GEIHIXykWWGct6fdNDF+KyT3rQrMs8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
