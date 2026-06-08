scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-06-08";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "bb6aeb439d447286961608163a3f359e3427aec2";
    hash = "sha256-m3eSk7dhWIEorC+m0GjfTFnyZHmNqZmrofflzLhQLH0=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
