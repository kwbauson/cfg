scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-05-25";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "4d6408b7dc2cfad0e68530ef81d16d75ee61eb0f";
    hash = "sha256-VxP/nrSLjmETDO5mmmShHiz0m0HCwQJHfqyZZob37gU=";
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
