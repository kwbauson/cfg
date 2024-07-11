scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-07-08";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "c3e5a63d6d44d7e38e78dba88b712bfdae0036c2";
    hash = "sha256-tkNxEvCBnkg5OISb+ZrmbTBgy/zEsCUfHD3U35EzI+Q=";
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
