scope: with scope;
let
  patched = applyPatches {
    name = "nixpkgs-prefetch-npm-deps-ignore-bad";
    src = pkgs.path + "/pkgs/build-support/node/fetch-npm-deps";
    dontUnpack = true;
    patches = [ ./prefetch-npm-deps-ignore-bad.patch ];
  };
  inherit (callPackage patched { inherit prefetch-npm-deps; }) fetchNpmDeps prefetch-npm-deps;
  buildPackages = scope.buildPackages // {
    npmHooks = scope.buildPackages.npmHooks.override { inherit prefetch-npm-deps; };
  };
in
(buildNpmPackage.override { inherit fetchNpmDeps buildPackages; }) {
  inherit pname;
  version = "unstable-2023-09-27";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "f9ac965e18e17b67da269e7f050c04d3945c4c94";
    hash = "sha256-onWjv2mT5XV8i8uFsfT2OMjXMgTaSlR63mDiCPhTnQ8=";
  };
  npmDepsHash = "sha256-Gd6+80BV2cGAVxyETmbNp0vQ91T+Wu8SQoHa/RrEPHY=";
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
