scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "20310d7b7eaf5dd66df0aa3b1eee601414d08cd6";
    hash = "sha256-wOaE28ivUB37/WpyyDoE+Ho3+Lj3jUZYDXXZnWmZFpQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
