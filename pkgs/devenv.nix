scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-19";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "169d2cbce65977289f2e0e863a4e8f42f9ce98af";
    hash = "sha256-SXTz20R4ZDXwr3iPxXJXQTftHmZwOPzSpIK7bIIculA=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
