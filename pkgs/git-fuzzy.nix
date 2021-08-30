scope: with scope; stdenv.mkDerivation {
  inherit name src;
  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r $src $out/share/${name}
    echo '#!/usr/bin/env bash' >> $out/bin/${name}
    echo '${pathAdd [ fzf bat exa ]}' >> $out/bin/${name}
    echo $out/'share/${name}/bin/${name} "$@"' >> $out/bin/${name}
    chmod +x $out/bin/*
  '';
}
