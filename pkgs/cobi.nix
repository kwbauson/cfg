scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0d80db257b57d1b738ee31e4f16c9e5df30a7fda";
    hash = "sha256-Gb9l0GmtlIiie/OwjwKE0EPMAqHL0KebQJQCJQGH0Hs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
