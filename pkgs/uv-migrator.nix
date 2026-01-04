scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2026.1.0-unstable-2026-01-03";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "71b73d2ad6d6cda481aa1134d95aea79bcb3f351";
    hash = "sha256-O5mdzbbzsZ6LreRTwaof/kZziaqw/ZkZEbxH+N7F6mk=";
  };
  cargoHash = "sha256-hrmjnPXOHH32c2bHcy/jc0O7+clQBizy1xZ9fmKuLr0=";
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
