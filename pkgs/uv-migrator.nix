scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.8.2-unstable-2025-06-20";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "ccb2afd304d6bd8864b5c28f890c016b39dbe3bd";
    hash = "sha256-ZrHMCfkNz+Ufae1Ylze4poPtYSb8PvW56juR3iLYIOk=";
  };
  cargoHash = "sha256-0t18fKYOp6qF+V24tPLK9IUUYp8OTghlT4j3qxqc9kw=";
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/uv-migrator --prefix PATH : ${makeBinPath [ uv_050 ]}
  '';
  meta.mainProgram = pname;
  meta.skipBuild = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { tagPrefix = "v"; })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
