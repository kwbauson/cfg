scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "af420cd3679399aa1fd30f3b34592545f3a307ae";
    hash = "sha256-FnS6hSMUAKv4Et4J2FeVZySmw1quuDkzFUKaWrg6HGQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
