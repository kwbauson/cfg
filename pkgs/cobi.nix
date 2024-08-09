scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d9e88ed1bd81907f2663fc4233476a4379a9f093";
    hash = "sha256-vKU2qZMNSsRp0G61BkPa/q9B8SvFJUVz4/PYkXjdSjc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
