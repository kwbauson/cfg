scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-10-14";
  src = fetchFromGitHub {
    owner = "splitbrain";
    repo = pname;
    rev = "530215c37db1f23ea8e67695fdc052a597d08ab0";
    hash = "sha256-/NRJXlnQcO5lkWPnupAV8+yYrV1db2vL/mZcR0fYL54=";
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
