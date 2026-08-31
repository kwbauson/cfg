scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-08-31";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "03f2c7fd60046eb92c18407cf4e0eb2e94b5fdd1";
    hash = "sha256-vWWxda+GMrjHpJtjG69ykvFjLG8Fw1f3dlvYUfoskJE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
