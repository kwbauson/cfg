scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-11-13";
  src = fetchFromGitHub {
    owner = "splitbrain";
    repo = pname;
    rev = "9ac39663feb4736632c2adc6035690518c380242";
    hash = "sha256-UQ/SrynRUiZV6Cp7fRR8o7/Me+nzQTjeNhqqiA1k5X4=";
  };
  buildInputs = with xorg; [ pkg-config cairo libXfixes libXrandr libXcomposite ];
  installPhase = ''
    mkdir -p $out/bin
    cp clipscreen $out/bin
  '';
  meta.mainProgram = pname;
  meta.platforms = platforms.linux;
  passthru.updateScript = unstableGitUpdater { };
}
