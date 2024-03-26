scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6b4b6f35c00c2b2dba0f84eba32d0b1d2979c301";
    hash = "sha256-z76DxJQR84njha1BcadpjbzI7BdR8d1jtcM+xScQnqg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
