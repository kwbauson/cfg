scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "13719221594521cc6fbe9987fc7ef857c4465236";
    hash = "sha256-TQT/y6QtZzV7L0IpQcsjPuIDcuZvLKiSu8q2WJ9syw8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
