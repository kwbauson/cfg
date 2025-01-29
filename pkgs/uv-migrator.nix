scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.5.0-unstable-2025-01-25";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "fb40a8781d8cb03057095f905677e8a02f78310d";
    hash = "sha256-iHBEC8vVZfHg5ZhOvTveGXSMNKuq1K/5Hy1j0AVk/Yo=";
  };
  cargoHash = "sha256-bC2ZoiUgXLh20VDG5j02paC7ln9HsPJW29kvrlQyueA=";
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/uv-migrator --prefix PATH : ${makeBinPath [ uv_050 ]}
  '';
  meta.mainProgram = pname;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { tagPrefix = "v"; })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
