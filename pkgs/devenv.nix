scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-13";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "5a30b9e5ac7c6167e61b1f4193d5130bb9f8defa";
    hash = "sha256-vHyIs1OULQ3/91wD6xOiuayfI71JXALGA5KLnDKAcy0=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
