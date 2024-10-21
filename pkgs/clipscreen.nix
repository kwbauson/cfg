scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-10-16";
  src = fetchFromGitHub {
    owner = "splitbrain";
    repo = pname;
    rev = "788c1458886b7484d72e1cd512ec5b3a01c90190";
    hash = "sha256-9Um8CF+/ntX9R7ZIqZjs80Vkkxga05N/LRBIex1wdSg=";
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
