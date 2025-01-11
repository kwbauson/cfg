scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2dad8d1203ac067a5b11b52e4277f316cb6e8e79";
    hash = "sha256-N2i2O9SYRbq+1i8ujHa2XQRJ+zf/VKQiPu0Hltg9dlI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
