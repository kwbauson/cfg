scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-28";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "5ab84abbf50500009cfd1da54d6e97666a69600f";
    hash = "sha256-9wJHxT+anpB0lr5DNK6AwF9bF73SJ/MypjnfDidix1s=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
