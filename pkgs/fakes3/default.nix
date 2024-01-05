scope: with scope;
bundlerApp {
  inherit pname;
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
