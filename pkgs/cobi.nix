scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b55c3699d0626f2ea57d1edeebb29d1e7efee90a";
    hash = "sha256-9Q+hJUU3VraNbikuloIEiBWQej1hEy6a1dUi85mL/Lo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
