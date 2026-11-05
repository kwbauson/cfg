scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-11-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "99ed5eb0a58e77fc499f747bc7ac26bc90c459ae";
    hash = "sha256-M4wW3uaCI7kGVLNmJrEMBKp5bTWvSymJGNWz3fnBPZw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
