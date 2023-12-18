scope: with scope;
buildGoModule {
  inherit pname;
  version = "unstable-2023-08-29";
  src = fetchFromGitHub {
    owner = "scribble-rs";
    repo = "scribble.rs";
    rev = "b4ac83145eae1bfb674ccb9112312cc77ff0adaa";
    hash = "sha256-i4XGllrIJODi/Vyo2nK5UjJfU/2dDt2wjzAjqRLCse4=";
  };
  vendorHash = "sha256-xdadV4WPY7cmsXf+nyPsFCXNTSxLhkau8GZtLopDcuY=";
  patches = [
    # (fetchpatch {
    #   url = "https://github.com/dataisbaye/scribble.rs/pull/2.patch";
    #   hash = "sha256-G6gAbwVpXeV2Etsr4WrYKd8B+wlKbFHR4JobjbueYFY=";
    # })
    ./choose-ten.patch
  ];
  doCheck = false;
  # passthru.updateScript = _experimental-update-script-combinators.sequence [
  #   (unstableGitUpdater { })
  #   (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  # ];
}
