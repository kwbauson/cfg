scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-02-12";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "9b6846f25f33c82a1b7af6e7c9a5a013eeb9b702";
    hash = "sha256-T2jbMMNckTLN7ejH+Fl2T4wAALGExiE3+DohZjxa1y4=";
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
