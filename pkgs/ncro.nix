scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-07-16";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "8681ec50b9570de825786f9ec599b1301214a1ff";
    hash = "sha256-E4sJw/ySR3bEGd3eyqXErmDtjj0TF+8JGYXH9uDPctc=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
