scope: with scope;
let
  patched-nixpkgs = applyPatches { src = pkgs.path; patches = [ ./prefetch-npm-deps-ignore-bad.patch ]; };
  patched-pkgs = import patched-nixpkgs { inherit system; config = { }; overlays = [ ]; };
in
patched-pkgs.buildNpmPackage {
  inherit pname;
  version = "unstable-2023-02-10";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "e1ac000cd1f15642218e80ded98ee19188cf2b17";
    hash = "sha256-7wKpUYm6KxNy4W8i4Hcctw6jSiV0+gbz0FnuEcqmjpM=";
  };
  npmDepsHash = "sha256-vMTShIpGjubcEgGqMZM9zqoUaAhV/dB8Xh9EH+gB2b8=";
  makeCacheWritable = true;
  patches = [ ./jitsi-meet-changes.patch ];
  nativeBuildInputs = [ python3 pkg-config ];
  buildInputs = [ pango ];
  RN_WEBRTC_SKIP_DOWNLOAD = "1";
  buildPhase = ''
    make compile deploy source-package
  '';
  installPhase = ''
    tar xf jitsi-meet.tar.bz2
    mv jitsi-meet $out
  '';
  meta.platforms = platforms.linux;
  # passthru.updateScript = _experimental-update-script-combinators.sequence [
  #   (unstableGitUpdater { })
  #   (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  # ];
}
