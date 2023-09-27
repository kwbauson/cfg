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
  version = "unstable-2023-09-26";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "e1dc573c3cca8b617b28e3e048f5a0a494f3225f";
    hash = "sha256-eOok/P6BTH/C0IcgagZuCpMHxn4riFZjLqwQvWKjYzQ=";
  };
  npmDepsHash = "sha256-hPQ1O2Zitehpad1VSyFrh9nQyFT0N9pD+xXWAJxoz3Q=";
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
