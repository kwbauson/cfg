scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4e007098e8fb7192e97f43cebece945ec180957f";
    hash = "sha256-s3YjhzlJIftKJavISnH5kBfQ/1mFK6gi02mSqF6H82U=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
