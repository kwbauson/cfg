scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e7ce25c5520d9158c1e3e30283faa99c5999c116";
    hash = "sha256-O0d6Lk2bACSDtxqMwpviYtlPYUACmKDiy/Anb22/uFg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
