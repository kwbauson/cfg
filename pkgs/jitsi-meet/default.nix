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
  version = "unstable-2023-09-13";
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "de2688bb33896da28fd01f6081e3763f6e827fb0";
    hash = "sha256-WWMDyeIlVCtZSP75zqjMLk269uYP0+vrjCZ45rV0EI0=";
  };
  npmDepsHash = "sha256-bq0ke2XMWGAssSyETJLZHTdJQfOi4mI3jY7GV/FDHU8=";
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
