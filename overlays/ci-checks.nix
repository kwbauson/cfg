final: prev: {
  ci-checks = with final.scope; let
    mkCheck = f: attrs: writeBashBin "ci-checks" ''
      echo ${linkFarm "ci-build" (mapAttrValues f attrs)}
      ${better-comma}/bin/, -p hello hello
    '';
  in
  {
    x86_64-linux = mkCheck (conf: conf.config.system.build.toplevel) nixosConfigurations;
    aarch64-darwin = mkCheck (conf: conf.system) darwinConfigurations;
  }.${final.system};
}
