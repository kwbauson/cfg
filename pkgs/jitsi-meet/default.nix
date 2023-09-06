scope: with scope;
let
  patched = applyPatches {
    name = "nixpkgs-prefetch-npm-deps-ignore-bad";
    src = pkgs.path + "/pkgs/build-support/node/fetch-npm-deps";
    dontUnpack = true;
    patches = [ ./prefetch-npm-deps-ignore-bad.patch ];
  };
  inherit (callPackage patched { inherit prefetch-npm-deps; }) fetchNpmDeps prefetch-npm-deps;
  npmHooks = scope.npmHooks.override {
    buildPackages = buildPackages // { inherit prefetch-npm-deps; };
  };
in
(buildNpmPackage.override { inherit fetchNpmDeps npmHooks; }) {
  inherit pname;
  version = "unstable-2023-09-05";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "a95eaa6c2efe38dd42f3b5c55f887274d4a68e34";
    hash = "sha256-Km6UvgKQt871sB/SRSrYmIwuHT3dJ4w1IqPlMp/8VGo=";
  };
  npmDepsHash = "sha256-d83PObytcDowNQHGKNxRrrSDl7wyQMqWXGOagbjFGWQ=";
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
