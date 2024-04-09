scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5e7a8982ebebc7b5698da808b385745aed830c35";
    hash = "sha256-HM9BGMXrOWvTCiDydfINngVhfYtnV+q/fQTaH3Kpu7o=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
