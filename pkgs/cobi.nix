scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a83365a3aaabf9b16c8d1c6925c6f485829803b4";
    hash = "sha256-/oQWbpvS70LLWhVMKL0N5jlJLEaFJoE1KlSa2GH7puk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
