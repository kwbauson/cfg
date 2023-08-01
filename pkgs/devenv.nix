scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-31";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "e91205acb792f6a49ea53ab04c04fbc2a85039cd";
    hash = "sha256-k4Cb2/Yx2kL8TFuVejwEk4R0J+5sxbydAj2IZBKZg7o=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
