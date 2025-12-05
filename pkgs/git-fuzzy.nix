scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-12-04";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "94994df792eb16638aea9a9726eac321bb6da2ca";
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
