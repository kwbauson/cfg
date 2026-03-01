scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-02-25";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "c677a38617e3fa7f214d2608c00152665b571525";
    hash = "sha256-WRi67PrS+xdJz6UYxtyeBJx3c2ncmtNLJ8w+zq1d+yQ=";
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
