scope: with scope;
vimPlugins.barbar-nvim.overrideAttrs (attrs: {
  patches = attrs.patches or [ ] ++ [ ./barbar-show-parent-option.patch ];
  # FIXME update patch to work with latest
  src = attrs.src.override {
    rev = "e7521487be265773f81200a2628b141c836c089b";
    sha256 = "sha256-rW27fHpPVs4gXVqxnnsFxOITBGMjl35Iiaq4q9dGHYY=";
  };
  doCheck = false;
})
