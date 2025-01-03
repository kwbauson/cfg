scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8848d309675c2c3932951dac0ccb1b06b68e1c35";
    hash = "sha256-+GP8IG5IpPmCvMqM02p7tQcHMnYaUlFPZFD4knXlMek=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
