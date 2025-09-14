scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b42b85f69bb24f7faa530a11512bd701e8546e7b";
    hash = "sha256-znbtFXLV5qtUMjsK0AAnJ1IKjRvSHY5qZloYUwYf50o=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
