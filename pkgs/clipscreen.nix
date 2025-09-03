scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-08-31";
  src = fetchFromGitHub {
    owner = "splitbrain";
    repo = pname;
    rev = "a4aaee4376a040ecca5f6024bd026974a4fafa25";
    hash = "sha256-ZVWhrIqFOQxConBDkEKbtlOoeoEHPhBpTap9TZjpcMg=";
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
