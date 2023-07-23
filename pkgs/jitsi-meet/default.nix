scope: with scope;
let
  src = fetchFromGitHub {
    owner = "jitsi";
    repo = pname;
    rev = "e1ac000cd1f15642218e80ded98ee19188cf2b17";
    sha256 = "sha256-7wKpUYm6KxNy4W8i4Hcctw6jSiV0+gbz0FnuEcqmjpM=";
  };
  node_modules = mkYarnModulesWithRebuild {
    packageJSON = "${src}/package.json";
    yarnLock = ./yarn.lock;
    extraNativeBuildInputs = [ pango ];
    preRebuild = "export RN_WEBRTC_SKIP_DOWNLOAD=1";
  };
  jitsi-meet-source-package = stdenv.mkDerivation {
    name = "jitsi-meet.tar.bz2";
    inherit src;
    patches = [ ./changes.patch ];
    NODE_OPTIONS = [ "--openssl-legacy-provider" "--max_old_space_size=8192" ];
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
  passthru = { inherit jitsi-meet-source-package; };
  passthru.jitsi-src = src;
  passthru.updateScript = null;
  # passthru.updateScript = writeBashBin "update-jitsi" ''
  #   ${ pathAdd [ yarn coreutils ] }
  #   set -eo pipefail
  #   dir=$(mktemp -d /tmp/update-jitsi.XXXXX)
  #   cd "$dir"
  #   cp --no-preserve=mode ${src.jitsi-meet}/package{,-lock}.json .
  #   yarn import --ignore-engines
  #   cd -
  #   cp "$dir"/yarn.lock pkgs/jitsi-meet
  #   rm -r "$dir"
  # '';
})
