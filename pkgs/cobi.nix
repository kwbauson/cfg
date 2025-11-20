scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0f72b423a7db95686f9007e008371a3b99f925c8";
    hash = "sha256-6Tfd4kTnDNbu9CDY/+XXSaiqN7zuWVKSspxtr2gvY/I=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
