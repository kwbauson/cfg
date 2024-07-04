scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6ac694d7cba59969386ad03a19dd91d549ec35e8";
    hash = "sha256-NKeuWTF9Bge7zRkVjBGw26dg8EnT3SuotvzxcyArX9I=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
