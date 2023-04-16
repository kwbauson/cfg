final: prev: with final.scope; {
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
  ci-checks =
    let
      mkCheck = f: attrs: writeBashBin "ci-checks" ''
        echo ${linkFarm "ci-build" (mapAttrValues f attrs)}
        echo ${checks}
        ${better-comma}/bin/, -p hello hello
      '';
    in
    {
      x86_64-linux = mkCheck (conf: conf.config.system.build.toplevel) nixosConfigurations;
      aarch64-darwin = mkCheck (conf: conf.system) darwinConfigurations;
    }.${final.system};
}
