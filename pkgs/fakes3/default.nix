scope: with scope;
bundlerApp {
  inherit pname;
  ruby = (ruby_2_7.overrideAttrs (old: {
    meta = removeAttrs old.meta [ "knownVulnerabilities" ];
  })).override {
    openssl_1_1 = openssl_1_1.overrideAttrs (old: {
      meta = removeAttrs old.meta [ "knownVulnerabilities" ];
    });
  };
  gemdir = ./.;
  exes = [ pname ];
  passthru.tests.default = makeTest ''
    ${getExe fakes3} --help
  '';
  passthru.updateScript = writeShellScript "update" ''
    ${pathAdd [ bundler bundix ]}
    cd pkgs/fakes3
    bundler lock --update
    bundix
  '';
}
