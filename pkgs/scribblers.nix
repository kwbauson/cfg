scope: with scope;
buildGoModule {
  inherit pname;
  version = "0-unstable-2024-11-11";
  src = fetchFromGitHub {
    owner = "kwbauson";
    repo = "scribble.rs";
    rev = "c8d617c8767670668763367325ceb03ae9007225";
    hash = "sha256-K4hRoCt2TGgF3+1V/f+sDHlz7vgosHAZWsJkQ4xyou4=";
  };
  vendorHash = "sha256-xdadV4WPY7cmsXf+nyPsFCXNTSxLhkau8GZtLopDcuY=";
  doCheck = false;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
