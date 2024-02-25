scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "59ed571fce26b2b3e13f3db6cb0d1b3bcccf80a9";
    hash = "sha256-QFez+tO8WFjSM1SH7MOoAWuauCm3iVHcmlobaWEuvX8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
