scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-04-24";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "827663a660a4e3b8d8b7002bc3bef71a0de48c05";
    hash = "sha256-f58IWHIG/9C7upP/DoxLeK1jAtTr3PSZoTK+tRGodZQ=";
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
