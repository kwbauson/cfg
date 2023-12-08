scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-07";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "1b7acfe81589bf34d49ccc34bafb27f5af654f04";
    hash = "sha256-M3DSiJiJ5yys33dw66Fl/wFN9qAccs+n7G/yf81RZW8=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
