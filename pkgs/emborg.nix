scope: with scope; prev.overrideAttrs (attrs: {
  propagatedBuildInputs = attrs.propagatedBuildInputs ++ [ prev.pythonModule.pkgs.nestedtext ];
  meta = attrs.meta // {
    mainProgram = "emborg";
  };
  passthru.tests.default = makeTest ''
    ${getExe emborg} --help
  '';
})
