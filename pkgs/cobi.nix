scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b13837b800ab8c2afe909de5395c6b5b1de5c3bd";
    hash = "sha256-fliePGJwCv5Nu6mz+XLNlI0dzl0j5zHFfPZDpYKLBcI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
