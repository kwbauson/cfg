scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6ed22cc64c3fd6c0aecf66baa4258dd3ef458553";
    hash = "sha256-Lhn9ZFY4jXS0aRhQSP75oEO18oPMDtSEHA4PuKdPifA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
