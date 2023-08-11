scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-08-10";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "fb02ba3522e19ae1c69be80e2a58561fe2416155";
    hash = "sha256-Eo2TCx3w3SppoXi8RZu8EC1NhLOnL39bFliHDc2YsyM=";
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
