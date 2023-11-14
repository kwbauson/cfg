scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-13";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "f075a8a1a2d463ca7b135c25da3c62a7c5c51e86";
    hash = "sha256-lzJWdhG+x5RkMJ3aaMmNV7g79Sku2jytNDX+dCsxHC8=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
