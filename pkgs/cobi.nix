scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "08c899584c56fa79923af042c74789c322f45f1f";
    hash = "sha256-JdrznDgpKvNH0o+xMXeHypfURpgeVoShikUQSpuBdMk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
