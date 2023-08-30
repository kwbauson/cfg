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
  version = "unstable-2023-08-29";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "0170c65c7b84979df5b74634134b4e93b0a35c4e";
    hash = "sha256-hri7R3Cs2FUsMEcViLQ0DybdOQ6AngKaiKD5hWu32Vo=";
  };
  npmDepsHash = "sha256-JrWwlLEivbmqvY/22cgCj7UXSLWjc1qR1d0jjKXM/oA=";
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
