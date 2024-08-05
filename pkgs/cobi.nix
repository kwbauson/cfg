scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b22848639f782eede3bb40244906eb5a17bfe641";
    hash = "sha256-eyXN/PTypkxJSfIimC+JR9TuTss6y476P/nBDTqOkno=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
