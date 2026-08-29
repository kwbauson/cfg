scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-08-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2279da7e6fe31b0c54ec2174b5fe9a4d2f9e77a7";
    hash = "sha256-9cDyeVNWJXwDXidsQgx9dS3YdU4i/hjJQ3CCnApz3uk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
