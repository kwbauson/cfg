scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-05-06";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "f41c7bed3a2ba0750d6639f59a2ee7906bd6cd23";
    hash = "sha256-WoZLgtKI72cmOClN/QjdxhlAQ/Ni2DObJMUUrsxXN6g=";
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
