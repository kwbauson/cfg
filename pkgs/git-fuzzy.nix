scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-02-06";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "e191b385d3460ec91c07e2c4ee339c918649b232";
    hash = "sha256-J9QS4fqaDCOAjyCwlvFKLlQ6/lzVQbmM9VwKh7V6AB8=";
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
