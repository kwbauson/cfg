scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "40f764b56546a0d46d381ca7471b8ad86104ac04";
    hash = "sha256-Zgp6m/ho+9oY0w7tiCfoQ/9JKkBqi+qgNMI0JXb2XpA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
