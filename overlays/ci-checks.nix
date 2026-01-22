final: prev: with final.scope;
let
  checks = linkFarmFromDrvs "checks" (flatten [
    (attrValues checked-extra-packages)
    (attrValues (forAttrValues checked-extra-packages (pkg: attrValues (pkg.tests or { }))))
  ]);
  checks-script = writeBash "checks" ''
    echo ${checks}
    ${exe better-comma} -p hello hello
    mkdir -p /tmp/nle-test
    cd /tmp/nle-test
    export NLE_CACHE=/tmp/nle-cache
    ${exe nle} clean
    ${exe nle} init
    echo "scope: with scope; [ hello ]" > local.nix
    ${exe nle}
    ${exe nle} uncache
  '';
in
{
  makeTest = commands: runCommand "test" { } ''
    ${writeShellScript "commands" ''
      set -xeuo pipefail
      ${commands}
    ''} > $out
    echo OK >> $out
  '';
  checked-extra-packages = filterAttrs
    (_: pkg: all id [
      (isDerivation pkg)
      (!pkg.meta.broken or false)
      (!pkg.meta.skipBuild or false)
      (elem system pkg.meta.platforms or [ system ])
    ])
    extra-packages;
  cached-paths =
    let
      getPaths = ns: machines: concatMap (m: map (n: "switch.scripts.${m}.${n}") ns) (attrNames machines);
      paths = {
        x86_64-linux = getPaths [ "noa" "nos" "nob" ] nixosConfigurations;
        aarch64-darwin = getPaths [ "noa" "nds" ] darwinConfigurations;
      }.${system};
    in
    create-cached-refs.mkRefPaths {
      inherit paths flake;
      appendSystem = false;
    };
  checks = runCommand "checks" { } ''
    mkdir -p $out/bin
    ln -s ${checks-script} $out/bin/checks
    ln -s ${final.cached-paths} $out/cached-paths
  '';

  requiredSubstitutes = {
    inherit ffmpeg;
  } // optionalAttrs isLinux {
    inherit firefox-unwrapped ffmpeg-full;
    chromium = chromium.browser;
  };
}
