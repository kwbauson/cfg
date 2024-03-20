scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8da895a0bbf8a698de6eb39a1bd45689b65e5d50";
    hash = "sha256-W7glnitQC/kkmdbyJ+b+WaOm2Psg+dYV3xcLcqW04JE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
