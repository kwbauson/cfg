scope: with scope;
let
  nodedir = runCommand "nodedir" { } ''
    tar xvf ${nodejs.src}
    mv node-* $out
  '';
  node_modules = runCommand "node_modules" { nativeBuildInputs = [ yarn nodejs python3 pkg-config gcc pango ]; } ''
    cp ${sources.jitsi-meet}/package.json .
    cp ${./yarn.lock} yarn.lock
    chmod +w yarn.lock
    ${yarn2nix-moretea.fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock
    export HOME=$PWD/yarn_home
    yarn config --offline set yarn-offline-mirror ${yarn2nix-moretea.importOfflineCache ./yarn.nix}
    yarn --offline --ignore-scripts --modules-folder $out
    cd $out
    patchShebangs .
    export RN_WEBRTC_SKIP_DOWNLOAD=1
    npm rebuild --nodedir=${nodedir}
  '';
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
    ${ pathAdd [ yarn yarn2nix coreutils ] }
    set -eo pipefail
    dir=$(mktemp -d /tmp/update-jitsi.XXXXX)
    cd "$dir"
    cp --no-preserve=mode ${sources.jitsi-meet}/package{,-lock}.json .
    yarn import
    yarn --ignore-scripts
    yarn2nix > yarn.nix
    cd -
    cp "$dir"/yarn.{lock,nix} pkgs/jitsi-meet
    rm -r "$dir"
  '';
})
