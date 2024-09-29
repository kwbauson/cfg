scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f6d822050fcfe057946ca125f7e0c1161fc699ba";
    hash = "sha256-LIx9buAN08QNrBpodLg9kiXZ8LqARUWIiOe9n5QnoeQ=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
