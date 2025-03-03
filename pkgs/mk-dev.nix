scope: with scope;
let
  mkDev = arg: fix (result: (
    if isAttrs arg then mkDevFromAttrs arg
    else if isList arg then mkDevFromAttrs { packages = arg; }
    else if isFunction arg then mkDev (arg result)
    else throw "${pname}: must be called with attrs, list, or function"
  ));
  mkDevFromAttrs =
    { name ? "dev-shell"
    , packages ? [ ]
    , meta ? { }
    , ...
    }@attrs: fix (result:
    let
      expectedArgs = [ "name" "packages" ];
      expectedMkShellArgs = subtractLists expectedArgs (attrNames (functionArgs mkShell));
      isMinimal = !any (a: hasAttr a attrs) expectedMkShellArgs;
      mergeableAttrs = removeAttrs attrs (expectedArgs ++ [ "shellHook" "passthru" "meta" ]);
      passthru = {
        inherit pkgs;
        env = buildEnv {
          name = "${name}-build-env";
          paths = attrs.packages or [ ]
            ++ attrs.buildInputs or [ ]
            ++ attrs.nativeBuildInputs or [ ]
            ++ attrs.propagatedBuildInputs or [ ]
            ++ attrs.propagatedNativeBuildInputs or [ ];
        };
        print-dev-env = writers.writeBashBin "print-dev-env" ''
          cat ${writeText "dev-env" (toShellVars result.drvAttrs)}
        '';
      } // attrs.passthru or { };
      buildPhase = attrs.buildPhase or "${coreutils}/bin/ln -s ${result.env} $out";
      shellHook = ''
        if [[ $NIX_BUILD_TOP != /tmp && -e $NIX_BUILD_TOP ]];then
          rmdir "$NIX_BUILD_TOP"
        fi
        unset NIX_BUILD_CORES NIX_BUILD_TOP NIX_STORE
        unset TEMP TEMPDIR TMP TMPDIR
        ${attrs.shellHook or ""}
      '';
      baseMinimalDrvAttrs = {
        inherit name system;
        builder = "${bash}/bin/bash";
        args = [ "-c" buildPhase ];
        outputs = [ "out" ];
        shellHook = ''
          unset ${concatStringsSep " " (attrNames baseMinimalDrvAttrs)}
          unset dontAddDisableDepTrack out
          ${shellHook}
        '';
      };
      extraMinimalDrvAttrs = {
        PATH = "${result.env}/bin";
        XDG_DATA_DIRS = "${result.env}/share";
      };
      minimalShell = derivation (baseMinimalDrvAttrs // extraMinimalDrvAttrs) // passthru // { inherit meta; };
      stdenvShell = mkShell ({ inherit name packages shellHook buildPhase passthru meta; } // mergeableAttrs);
    in
    if isMinimal then minimalShell else stdenvShell);
in
stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  script = ''
    #!${getExe bash}
    set -euo pipefail
    if [[ -e default.nix || -e .envrc ]];then
      echo "default.nix or .envrc already exists, doing nothing"
      exit 1
    fi
    echo 'use nix' > .envrc
    mainRev=$(${getExe curl} -s 'https://api.github.com/repos/kwbauson/cfg/commits/main' | ${getExe jq} -r .sha)
    cat > default.nix <<-EOF
    { mk-dev ? (import (fetchTarball "https://github.com/kwbauson/cfg/archive/$mainRev.tar.gz") {}).mk-dev
    , pkgs ? mk-dev.pkgs
    }: with pkgs; mk-dev [
    ]
    EOF
    $EDITOR default.nix
    direnv allow
  '';
  passAsFile = [ "script" ];
  installPhase = ''
    mkdir -p $out/bin
    cp "$scriptPath" $out/bin/${pname}
    chmod +x $out/bin/${pname}
  '';
  meta.includePackage = true;
  passthru = {
    inherit pkgs;
    __functor = _: mkDev;
  };
}
