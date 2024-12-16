scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0012da47061007376ab289d2e5e0e408df0af846";
    hash = "sha256-6wDArwhD8/hEifn6vnVuGQQDFJX/9ysvVFDnY/MypsA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
