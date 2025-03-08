scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3b64ee21efc92a849ebb0c74817d4701e9238a3e";
    hash = "sha256-ILrUfi2ARgoyTb1MHgJNBxc8iQzLWZKX1N23hHLiQCI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
