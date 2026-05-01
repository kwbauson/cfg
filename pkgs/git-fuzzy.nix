scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2026-04-30";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "f5c4a57b49c03136ca2dc5e2534ef62a39904f64";
    hash = "sha256-GoSw8iAZgdE27C2sl+mYj9hzcYrlbX9XNIb1CUuXDq8=";
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
