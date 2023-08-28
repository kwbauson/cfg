scope: with scope;
buildGoModule {
  inherit pname;
  version = "unstable-2023-08-26";
  src = fetchFromGitHub {
    owner = "scribble-rs";
    repo = "scribble.rs";
    rev = "00b9d0dc855158d539797d45d6858b0ee232bb23";
    hash = "sha256-+lSeu0OAnlYy5bym7rnfg+qvg39Sf5+DpwmDNqId4P4=";
  };
  vendorHash = "sha256-EjagOu1L27D1AkyP78VRMR+QULGLdAxGJusUsi8JEr4=";
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
