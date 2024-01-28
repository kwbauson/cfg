scope: with scope;
buildGoModule {
  inherit pname;
  version = "unstable-2024-01-28";
  src = fetchFromGitHub {
    owner = "kwbauson";
    repo = "scribble.rs";
    rev = "3597bb7147e54fa6c8dd9ff05df02a23dfac7aca";
    hash = "sha256-IKMZBYgtbaToQ87Ivtvs3KHtlv0UC+3xVs6rHoi+p64=";
  };
  vendorHash = "sha256-xdadV4WPY7cmsXf+nyPsFCXNTSxLhkau8GZtLopDcuY=";
  doCheck = false;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
