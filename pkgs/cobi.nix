scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-09-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6f39120e1871696e80d0415ff4ca9f00656b0a3b";
    hash = "sha256-MR/hE45efD9CxSAQb+JxRe7Kwh2D+WjSJCyoRKMz0T8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
