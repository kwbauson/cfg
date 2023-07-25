final: prev: with final.scope;
let
  checks = linkFarmFromDrvs "checks" (flatten [
    (attrValues checked-extra-packages)
    (nle.build { path = writeTextDir "meme" ''meme''; })
    (attrValues nle.scripts)
  ]);
  checks-script = writeBash "checks" ''
    echo ${checks}
    ${exe better-comma} -p hello hello
    mkdir -p /tmp/nle-test
    cd /tmp/nle-test
    ${exe nle} init
    echo "scope: with scope; [ hello ]" > local.nix
    ${exe nle}
    ${exe fakes3} --help
  '';
  getSwitchScripts = names: concatMapAttrs (machine: _: listToAttrs (map (name: nameValuePair "${machine}-${name}" switch.${machine}.${name}) names));
in
{
  checked-extra-packages = filterAttrs
    (_: pkg: all id [
      (isDerivation pkg)
      (!(pkg.meta.broken or false))
      (!pkg.meta.skipBuild or false)
      # (meta.availableOn system pkg)
    ])
    extra-packages;
  ci-checks = (forAttrValues
    {
      x86_64-linux = getSwitchScripts [ "noa" "nos" "nob" ] nixosConfigurations;
      aarch64-darwin = getSwitchScripts [ "noa" "nds" ] darwinConfigurations;
    }
    (drvs: runCommand "ci-checks-env" { meta.mainProgram = "checks"; } ''
      mkdir -p $out/bin
      ln -s ${checks-script} $out/bin/checks
      ln -s ${linkFarm "builds" drvs} $out/builds
    '')
  ).${system};
  checks.default = final.ci-checks;
}
