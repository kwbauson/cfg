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
  makeTest = commands: runCommandLocal "test" { } ''
    # rebuild 1
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

  checks = cached-refs.build {
    inherit flake;
    refs = [ [ "hello" ] ] ++ rec {
      getPaths = ns: machines: concatMap (m: map (n: [ "switch" "scripts" m n ]) ns) (attrNames machines);
      x86_64-linux = getPaths [ "noa" "nos" "nob" ] nixosConfigurations;
      aarch64-darwin = getPaths [ "noa" "nds" ] darwinConfigurations;
    }.${system};

    postBuild = ''
      mkdir -p $out/bin
      ln -s ${checks-script} $out/bin/checks
    '';
  };

  requiredSubstitutes = optionalAttrs isLinux {
    inherit firefox-unwrapped ffmpeg-full;
    chromium = chromium.browser;
  };
}
