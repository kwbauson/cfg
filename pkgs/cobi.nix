scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2fb6ce1043e3cc413ead2b46eacfceb302be346b";
    hash = "sha256-IqnfhkLLeD4K02AsLofBYeoow3gU5wBuGqLX2FuXmHE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
