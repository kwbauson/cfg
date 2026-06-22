scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-06-18";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "5e5ec3956dfc9b3b9593b77ad41f8267821149e6";
    hash = "sha256-yBdxEtF4Wmygs8JdY3m43iKsHm8Dp3hblT9VhZ+YpkM=";
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
