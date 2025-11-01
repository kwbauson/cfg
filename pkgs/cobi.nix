scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d676024de5e8d04d6747987a994af4bdc538dbf8";
    hash = "sha256-bK0bJXAcTXKgNkZ38mc9XMD4JTYH0yFIwlB6pU4EiNo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
