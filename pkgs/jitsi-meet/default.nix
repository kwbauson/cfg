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
  version = "unstable-2023-09-21";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "f0cb33a627e6f2d6e2460a10f52b4b9c6f7746c7";
    hash = "sha256-0rFUi78dHh7qWW7yuL6yBCuk6N8ApPkC4BA1KphvO6g=";
  };
  npmDepsHash = "sha256-ODYWhEStsetV4i1o746jWlvDqU7WKCSS5WZVwakZ10o=";
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
