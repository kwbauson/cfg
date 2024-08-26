scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "aa23543354eb0c3100c048f6ae9b39fdb358b349";
    hash = "sha256-DJ616OfD2vyk2FGdmaq1vWv6U8rTTqiBN3gXaVPZn2Q=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
