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
  version = "unstable-2023-09-14";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "8304e77a040e512b8c6ec9bf094b191f136c1d96";
    hash = "sha256-8WJJ0pXZZ3r8M5q2iVaKm6QVwApjiX18xihtpkq/u1o=";
  };
  npmDepsHash = "sha256-8W5RLYa9/wp0hu4V4OoPPO2ZviVM7etCuewf6by+DpY=";
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
