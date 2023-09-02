scope: with scope;
buildGoModule {
  inherit pname;
  version = "unstable-2023-09-02";
  src = fetchFromGitHub {
    owner = "scribble-rs";
    repo = "scribble.rs";
    rev = "6dff30b531eeef9bddb6b3fc3814f50a1fd33f0e";
    hash = "sha256-oq54rfHisZA5sxLgjDvNoW8rsgk8uKHzOneO0ccW0DE=";
  };
  vendorHash = "sha256-xdadV4WPY7cmsXf+nyPsFCXNTSxLhkau8GZtLopDcuY=";
  patches = [ ./choose-ten.patch ];
  doCheck = false;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
