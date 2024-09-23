scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-09-21";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "a9299d78461c90fd24869f5a51f9afba6c46d68d";
    hash = "sha256-D4fOj4JAS/bIMK1h9Kg/DaEwlfNau4+N92+js99yrNs=";
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
