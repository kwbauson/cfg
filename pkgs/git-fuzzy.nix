scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-04-10";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "17040e6ce6ef65926a1dc15223b4c7c0a169bdc4";
    hash = "sha256-0h53oZ5vzlpgPgkDvIrInCc3cFEpoi5XtMUHAWWf/Ew=";
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
