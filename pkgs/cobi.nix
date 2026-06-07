scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "23a4259dd04c3c4f32e3d2e37db18e6bf6b1ac1c";
    hash = "sha256-jZ4/xcCOplu6qylhQAkfD+ms6HW5E0rgqHglBymAIto=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
