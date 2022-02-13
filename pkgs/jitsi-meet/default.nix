scope: with scope;
let
  yarnModules = yarn2nix-moretea.mkYarnModules {
    pname = "jitsi-meet-modules";
    inherit version;
    packageJSON = "${sources.jitsi-meet}/package.json";
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
  };
  jitsi-meet-source-package = stdenv.mkDerivation {
    name = "jitsi-meet.tar.bz2";
    inherit src;
    patches = [ ./changes.patch ];
    buildInputs = [ nodejs ];
    buildPhase = ''
      ln -s ${yarnModules}/node_modules .
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
  passthru.update-script = writeBashBin "update-jitsi" ''
    set -eo pipefail
    mkdir -p /tmp/update-jitsi
    cp pkgs/jitsi-meet/yarn.lock /tmp/update-jitsi
    cp --no-preserve=mode ${sources.jitsi-meet}/package.json /tmp/update-jitsi
    cd /tmp/update-jitsi
    yarn --ignore-scripts
    ${yarn2nix}/bin/yarn2nix > yarn.nix
    cd -
    cp /tmp/update-jitsi/yarn.{lock,nix} pkgs/jitsi-meet
  '';
})
