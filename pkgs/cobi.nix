scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-10";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1566b7052d151e7f0a7f45729a12c7f70d3c762f";
    hash = "sha256-//37ejrfzp1D/d3reu4J4UUtIgU6CLyo9Sl1G5ZqkJA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
