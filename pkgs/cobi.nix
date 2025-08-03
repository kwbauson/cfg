scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "92a03986a71c26b8c12aac60d200affb5b5bf09a";
    hash = "sha256-+V74M2nOBm8st6fLH0qU9bgTXH1PJ0QH/u+L9gbj+pU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
