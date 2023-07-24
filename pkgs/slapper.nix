scope: with scope;
buildGoPackage {
  inherit pname;
  version = "unstable-2019-08-28";
  src = fetchFromGitHub {
    owner = "ikruglov";
    repo = pname;
    rev = "552f8a34ae9ff4c74dfa7c83c62cda6028ae2f29";
    hash = "sha256-c/dXMIKE5CtjXQ7jJA6IiZpmWOgrFZnO3lDZOisYX30=";
  };
  goPackagePath = "github.com/ikruglov/slapper";
  passthru.updateScript = unstableGitUpdater { };
}
