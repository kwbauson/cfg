scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-07-18";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "0d20681d67b0270c2eab3cffc0cd792224d4833e";
    hash = "sha256-YqMs/sDriqREwP/b1NbLAVpJukISAqEh9HjdIl/DIjk=";
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
