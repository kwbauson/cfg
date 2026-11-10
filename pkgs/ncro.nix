scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.4.0-unstable-2026-11-10";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "7b1ff495b884fe955d36e1f8b87ed0491b33fa38";
    hash = "sha256-vdj4674VD2Hf0iKv0JMME2Kblrm0dYFfJ4pZbG6Uki0=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
