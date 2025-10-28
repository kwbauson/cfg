scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-10-27";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "9a847c78f721440960ec85e273b419c01193c7b2";
    hash = "sha256-hGbA/p1t1pTtou0dz/VSbwqd3CLsG/bpmb6Ou/jiZIE=";
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
