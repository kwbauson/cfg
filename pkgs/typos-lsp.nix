scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2024-02-05";
  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-vscode";
    rev = "68f1d4ceda255e74ccdb6b6bb941262e1b050e16";
    hash = "sha256-LzemgHVCuLkLaJyyrJhIsOOn+OnYuiJsMSxITNz6R8g=";
  };
  cargoHash = "sha256-f7tUgi+0WgbJdaO/vF0H8cC0o3aTAI2kN0q0yNDKZdc=";
  meta.mainProgram = pname;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
