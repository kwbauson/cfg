scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-02";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "8fddf191873b13733a966753dda2d6613c86ca15";
    hash = "sha256-GfWTR08/DoV/aj9YaP+ASg2vaLHtGsepFisWup5K/wE=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
