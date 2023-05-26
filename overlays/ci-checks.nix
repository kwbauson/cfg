final: prev: with final.scope;
let
  checks = linkFarmFromDrvs "checks" (flatten [
    slapper
    better-comma
    nle
    (optionals stdenv.isLinux [
      waterfox
      r2modman
      bundix
      poetry
      dasel
      pur
      (nle.build { path = writeTextDir "meme" ''meme''; })
    ])
  ]);
  ci-checks = writeBash "ci-checks" ''
    echo ${checks}
    ${exe better-comma} -p hello hello
    mkdir -p /tmp/nle-test
    cd /tmp/nle-test
    ${exe nle} init
    echo "scope: with scope; [ hello ]" > local.nix
    ${exe nle}
  '';
in
{
  ci-checks = (forAttrValues
    {
      x86_64-linux = mapAttrValues (conf: conf.config.system.build.toplevel) nixosConfigurations;
      aarch64-darwin = mapAttrValues (conf: conf.system) darwinConfigurations;
    }
    (drvs: runCommand "ci-checks-env" { meta.mainProgram = "ci-checks"; } ''
      mkdir -p $out/bin
      ln -s ${ci-checks} $out/bin/ci-checks
      ln -s ${linkFarm "builds" drvs} $out/builds
    '')
  ).${system};
}
