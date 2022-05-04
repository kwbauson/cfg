scope: with scope;
let
  node_modules = mkYarnModulesWithRebuild {
    packageJSON = "${sources.jitsi-meet}/package.json";
    yarnLock = ./yarn.lock;
    extraNativeBuildInputs = [ pango ];
    preRebuild = "export RN_WEBRTC_SKIP_DOWNLOAD=1";
  };
  jitsi-meet-source-package = stdenv.mkDerivation {
    name = "jitsi-meet.tar.bz2";
    inherit src;
    patches = [ ./changes.patch ];
    nativeBuildInputs = [ nodejs ];
    buildPhase = ''
      cp -r ${node_modules} node_modules
      ./node_modules/.bin/webpack
      make deploy source-package
    '';
    installPhase = ''
      mv jitsi-meet.tar.bz2 $out
    '';
  };
in
jitsi-meet.overrideAttrs (_: {
  src = jitsi-meet-source-package;
  passthru.updateScript = writeBashBin "update-jitsi" ''
    ${ pathAdd [ yarn coreutils ] }
    set -eo pipefail
    dir=$(mktemp -d /tmp/update-jitsi.XXXXX)
    cd "$dir"
    cp --no-preserve=mode ${sources.jitsi-meet}/package{,-lock}.json .
    yarn import
    cd -
    cp "$dir"/yarn.lock pkgs/jitsi-meet
    rm -r "$dir"
  '';
})
