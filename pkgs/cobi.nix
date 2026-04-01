scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "9a3a8de1ca81970ebf64c773c3ca9aa0301d7c90";
    hash = "sha256-vlBD1O8Kmpd22kteD2t00YsTK5Sa2+iXIGulz/Nvrj8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
