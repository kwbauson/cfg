scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "446cb154ba658b461d02a48b9c84ebc8c8432655";
    hash = "sha256-YzECVEkVovs8IHhRLsKClCYUWYP8+njLTfa3/6BZVW4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
