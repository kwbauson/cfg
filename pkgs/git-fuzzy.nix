scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-04-28";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "80929410eaecd53c87e9b9caedc08ae510434e6b";
    hash = "sha256-9wskWfpnBuyV15oI9uaVnh9iQF1QZ+Nx3QEABzmXcJs=";
  };
  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r $src $out/share/${pname}
    echo '#!/usr/bin/env bash' >> $out/bin/${pname}
    echo '${pathAdd [ fzf bat ]}' >> $out/bin/${pname}
    echo $out/'share/${pname}/bin/${pname} "$@"' >> $out/bin/${pname}
    chmod +x $out/bin/*
  '';
  passthru.updateScript = unstableGitUpdater { };
}
