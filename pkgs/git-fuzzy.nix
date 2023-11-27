scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-11-20";
  src = fetchFromGitHub {
    owner = "bigH";
    repo = pname;
    rev = "41b7691a837e23e36cec44e8ea2c071161727dfa";
    hash = "sha256-fexv5aesUakrgaz4HE9Nt954OoBEF06qZb6VSMvuZhw=";
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
