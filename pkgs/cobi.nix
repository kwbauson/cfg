scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "20c427dc895e64068fa441a6164143a2bf18974c";
    hash = "sha256-0oOJ8aD5eqN/LdnW1lbDDlaiF5fmTPoeWVjA0PVgBvo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
