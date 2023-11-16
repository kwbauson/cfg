scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-15";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "8960624339faa8701a03288692d1dfc4814dc0ae";
    hash = "sha256-T/wBaOKdz0IKnYf0DgpkX/lnkKJHk8n78byJZUnvZsg=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
