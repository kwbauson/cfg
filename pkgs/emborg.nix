scope: with scope;
prev.override {
  shlib = prev.pythonModule.pkgs.shlib.overrideAttrs (attrs: {
    postPatch = ''
      ${attrs.postPatch}
      sed -i '/^version = /alicense = { file = "LICENSE" }' pyproject.toml
    '';
  });
}
