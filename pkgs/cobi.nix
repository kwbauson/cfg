scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f6fdf3083318280d75a762982ac1ec0c07daeba9";
    hash = "sha256-qFbxEMfqIgXqZ4d/JkClzlkAdVHb/+cNrRWR9nC+WTo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
