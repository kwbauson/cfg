scope: with scope;
let
  patched-nixpkgs = applyPatches { src = pkgs.path; patches = [ ./prefetch-npm-deps-ignore-bad.patch ]; };
  patched-pkgs = import patched-nixpkgs { inherit system; config = { }; overlays = [ ]; };
in
patched-pkgs.buildNpmPackage {
  inherit pname;
  version = "unstable-2023-08-07";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "faea112f5e190459fe1032a0c754f50feb919a80";
    hash = "sha256-t7/7Wpp7EIKSFmmBPTSvcEjZLLJe8EfwYBCv/Eue8Jo=";
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
  passthru.updateScript = unstableGitUpdater { };
}
