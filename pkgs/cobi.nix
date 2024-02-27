scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "37ea8be416c88d6f8d12d48c14f63815ef997c86";
    hash = "sha256-jCVXFWu4MvW3CS3aQx7qA8+AxgHZ/G6WnrCX/2YckZs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
