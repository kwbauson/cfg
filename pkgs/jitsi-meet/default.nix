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
  version = "unstable-2023-08-16";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "4ac81b030ed2816b87ae74d3b415ab9c7285cdfa";
    hash = "sha256-bLCZBw0hS4RvlJVEgE9N1vyvBkJqjTNzP0dxLuZ0+L8=";
  };
  npmDepsHash = "sha256-1YVb2ZJmRI/B+2Y+8R1hEP45BYpOiaKSH/699Lnfk8E=";
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
