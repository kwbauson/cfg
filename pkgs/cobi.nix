scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0136c2b6c2f1353cb3cf412fd34fd12927514cf4";
    hash = "sha256-AWLhpmnMH+2ajsIPVBuu9d1Uvc2qjPX98g+CAeFSvQs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
