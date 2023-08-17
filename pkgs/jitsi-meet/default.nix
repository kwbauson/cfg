scope: with scope;
let
  patched = applyPatches { src = pkgs.path; patches = [ ./prefetch-npm-deps-ignore-bad.patch ]; };
  inherit (callPackage "${patched}/pkgs/build-support/node/fetch-npm-deps" { inherit prefetch-npm-deps; }) fetchNpmDeps prefetch-npm-deps;
  npmHooks = callPackage "${patched}/pkgs/build-support/node/build-npm-package/hooks" {
    buildPackages = buildPackages // { inherit prefetch-npm-deps; };
  };
in
(buildNpmPackage.override { inherit fetchNpmDeps npmHooks; }) {
  inherit pname;
  version = "unstable-2023-08-17";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "c19d91a373c64cde672e7cbb5830024062b82f6c";
    hash = "sha256-rbnvS00ubAWROup2MH0/vL8kr7bKpMo7ettqDoxtthE=";
  };
  npmDepsHash = "sha256-EXD91Pj4xPf7LUpbFrgk9WFm07nQ14LMG2LUvGmmvaY=";
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
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
