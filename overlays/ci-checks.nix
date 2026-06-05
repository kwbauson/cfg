final: prev: with final.scope;
let
  checked-pkgs = linkFarmOfHashes "checked-pkgs" (flatten [
    (attrValues checked-extra-packages)
    (attrValues (forAttrValues checked-extra-packages (pkg: attrValues (pkg.tests or { }))))
  ]);
  checks-script = writeBash "checks" ''
    set -euo pipefail
    echo ${checked-pkgs}
    ${exe better-comma} -p hello hello
    ${exe better-comma} -d hello
  '';
in
{
  getDrvHash = drv: substring 11 32 (builtins.unsafeDiscardStringContext drv.outPath);
  linkFarmOfHashes = name: drvs: linkFarm name (map (p: { name = getDrvHash p; path = p; }) drvs);
  makeTest = commands: runCommandLocal "test" { } ''
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
    extra-packages // { inherit zoom-us; };

  checks = cached-refs.build {
    inherit flake;
    refs = [ [ "hello" ] ] ++ rec {
      getPaths = ns: cs: concatMap (m: map (n: [ "switch" "scripts" m n ]) ns) (attrNames cs);
      x86_64-linux = getPaths [ "noa" "nob" ] nixosConfigurations;
      aarch64-darwin = getPaths [ "noa" ] darwinConfigurations;
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
