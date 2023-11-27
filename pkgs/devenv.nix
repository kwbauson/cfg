scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-22";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "38302f4b9ff45915151848b719c5c4127946c1b8";
    hash = "sha256-LidI1PVpxL5/WchIRfMszzsiA5t40QyJiU8V/vd4ZZE=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
