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
  buildInputs = [ pkg-config cairo libxfixes libxrandr libxcomposite ];
  installPhase = ''
    mkdir -p $out/bin
    cp clipscreen $out/bin
  '';
  meta.mainProgram = pname;
  meta.platforms = platforms.linux;
  passthru.updateScript = [
    (writeBash "what" ''
      ${nix}/bin/nix-instantiate --eval -E 'with import ./. {}; clipscreen.src.gitRepoUrl'
    '')
  ];
}
