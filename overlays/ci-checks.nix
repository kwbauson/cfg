final: prev: with final.scope;
let
  checks = linkFarmFromDrvs "checks" (flatten [
    (pipe extra-packages [
      (filterAttrs (_: pkg: all id [
        (isDerivation pkg)
        (!pkg.meta.broken or true)
        (elem system pkg.meta.platforms or [ system ])
      ]))
      (ps: attrValues (removeAttrs ps (flatten [
        "swarm" # too big
      ])))
    ])
    # (attrValues (removeAttrs (filterAttrs (_: isDerivation) extra-packages) (flatten [
    #   "swarm" # too big
    #   "evilhack" # broken
    #   (optionals isDarwin [
    #     "gameconqueror"
    #     "waterfox"
    #     "olivetin"
    #     "qutebrowser"
    #     "qtbr"
    #     "jitsi-meet"
    #   ])
    # ])))
    (nle.build { path = writeTextDir "meme" ''meme''; })
    (attrValues nle.scripts)
  ]);
  ci-checks = writeBash "ci-checks" ''
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
  ci-checks = (forAttrValues
    {
      x86_64-linux = getSwitchScripts [ "noa" "nos" "nob" ] nixosConfigurations;
      aarch64-darwin = getSwitchScripts [ "noa" "nds" ] darwinConfigurations;
    }
    (drvs: runCommand "ci-checks-env" { meta.mainProgram = "ci-checks"; } ''
      mkdir -p $out/bin
      ln -s ${ci-checks} $out/bin/ci-checks
      ln -s ${linkFarm "builds" drvs} $out/builds
    '')
  ).${system};
}
