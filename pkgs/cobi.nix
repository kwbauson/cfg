scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "27d1f1b2a4d84895afc58237eba541ff181d10c9";
    hash = "sha256-WWZ6BNXV7jZuDpMbuKfv2efHDa27axIAjdH5sv7wXSo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
