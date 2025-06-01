scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "154d9e1a37a5a1dd37c2afa241b5a05f9c805d98";
    hash = "sha256-nd9CpFZbOpVp7VVPV15sdLKo/PhgAFTLeMOCOOr5Q7s=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
