scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-09";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "be7e8358c1d871021e3d24acc67e2beb41830e10";
    hash = "sha256-uFYF67deIS6RPMzI7e+E+5QtlMZbrk+wYKz9GiTZOac=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
