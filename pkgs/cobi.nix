scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-10-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0ccc5a242070b7c41ab6b5be6504d07beb1bcd3a";
    hash = "sha256-val/ju2j8vcqKRrUTr3ny8btizsr6LiR3abRP8ANNnI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
