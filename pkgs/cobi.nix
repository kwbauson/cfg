scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ac5d2828122789e7d870a7e1497fdd492a05cebe";
    hash = "sha256-mtKcWI1CuYznwkARu0Ztb3PW379P12WKhevxVulaIjs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
