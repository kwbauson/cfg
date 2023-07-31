scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-07-30";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "b32342d9411420fba97de5aec7c601b9c44a7bd2";
    hash = "sha256-K+U3uejxbOIy6k6JPMC2tqRSj62JPF/GjkUT7CMNd80=";
  };
  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r $src $out/share/${pname}
    echo '#!/usr/bin/env bash' >> $out/bin/${pname}
    echo '${pathAdd [ fzf bat exa ]}' >> $out/bin/${pname}
    echo $out/'share/${pname}/bin/${pname} "$@"' >> $out/bin/${pname}
    chmod +x $out/bin/*
  '';
  passthru.updateScript = unstableGitUpdater { };
}
