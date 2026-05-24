scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-05-24";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "839eb134026a445feecccbf2c703849f292dada4";
    hash = "sha256-WU9Gs/ipuBU60XBV91gnIdY5wYGwQkXqp3ywRoC9zME=";
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
