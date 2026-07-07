{ _set, scope }: with scope;
let
  checked-pkgs = linkFarmOfHashes "checked-pkgs" (flatten [
    (attrValues check-all)
    (attrValues (forAttrValues check-all (pkg: attrValues (pkg.tests or { }))))
  ]);
  checks-script = writeBash "checks" ''
    set -euo pipefail
    echo ${checked-pkgs}
    ${full-checks-script}
  '';
  full-checks-script = pipe check-extra-packages [
    attrValues
    (filter (p: p ? checkScript))
    (concatMapStringsSep "\n" (pkg: /* bash */ ''
      OLD_PATH=$PATH
      ${pathAdd pkg}
      ${pkg.checkScript}
      export PATH="$OLD_PATH"
    ''))
  ];
  check-linux = { inherit zoom-us; };
  check-darwin = { inherit iterm2; };
  check-all = check-extra-packages // optionalAttrs isLinux check-linux // optionalAttrs isDarwin check-darwin;
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
  check-extra-packages = filterAttrs
    (_: pkg: all id [
      (isDerivation pkg)
      (!pkg.meta.broken or false)
      (!pkg.meta.skipBuild or false)
      (elem system pkg.meta.platforms or [ system ])
    ])
    (removeAttrs extra-packages (optionals isDarwin [ "qutebrowser" ]));

  checks = cached-refs.build {
    flake = cfg;
    refs = [ [ "legacyPackages" system "hello" ] ] ++ rec {
      getPaths = ns: cs: concatMap (m: map (n: [ "packages" system "switch" "scripts" m n ]) ns) (attrNames cs);
      x86_64-linux = getPaths [ "noa" "nob" ] nixosConfigurations;
      aarch64-darwin = getPaths [ "noa" ] darwinConfigurations;
    }.${system};
    bucket = "kwbauson-cached-refs";
    endpoint_url = "https://${constants.cloudflare.account_id}.r2.cloudflarestorage.com";

    postBuild = ''
      mkdir -p $out/bin
      ln -s ${checks-script} $out/bin/checks
    '';
  };

  required-substitutes = linkFarmOfHashes "required-substitutes"
    (mapAttrsToList (_: toDerivation) (optionalAttrs isLinux {
      inherit firefox-unwrapped ffmpeg-full;
      chromium = chromium.browser;
    }));
}
