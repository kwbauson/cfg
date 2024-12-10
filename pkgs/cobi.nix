scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c74c2a5cdf80a015bf9ae8fe004c25c951de1c5b";
    hash = "sha256-PVt8kp4c1QoQB+IScvYYxA8mhzE7v4DaPQqTd/OShKs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
