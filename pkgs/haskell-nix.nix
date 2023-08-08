scope: with scope;
importPackage {
  inherit pname;
  version = "unstable-2023-08-08";
  src = fetchFromGitHub {
    owner = "input-output-hk";
    repo = "haskell.nix";
    rev = "d7ff136e7fd2a73c740bcb0f9fd32c84fa446893";
    hash = "sha256-YWe6Ydc3gcv5Dn6bh3ZU/gE+E1xsGI4oI4QRXzHTG7g=";
  };
  passthru.updateScript = unstableGitUpdater { };
}
