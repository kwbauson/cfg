scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.8.3-unstable-2025-09-03";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "133c05e49ad68e3c8efc13d01512bf51ab6f3708";
    hash = "sha256-m/0bNzTSyO2ZgjUAGDjAy6VuSP+czTAa/wqiBOqTOhU=";
  };
  cargoHash = "sha256-kmCzI1LB9MFrZjXnU70QBm83sKcFdWkYR0vFmbiTYAE=";
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
