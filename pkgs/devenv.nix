scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-01-16";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "ff37923d4ba9e220b9826594e83fc29e1a4f4338";
    hash = "sha256-2nhAJ/9LMlwaEZDnoDIhnhQ0pEC/YIIt09WD7FmTp6g=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
