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
  version = "unstable-2023-08-14";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "e2a02f4b2165e3a018f8830c458beacfd2e8a9ee";
    hash = "sha256-0YMcvOetSyfkD7aKTAhfLzX0ikv3HBeBUrkhIUr+jKA=";
  };
  npmDepsHash = "sha256-3kabfnlN8B7lJHKFyH0Ii6FWOOPKsV3HEivp9skNlsU=";
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
