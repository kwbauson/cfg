scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2024-02-11";
  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-vscode";
    rev = "df666b3e934e61eba848df5bacd26103a8731396";
    hash = "sha256-B+LDz6saxvfOwyjl9wsPo8pJZI0T7KQsUmkN0YjfhmI=";
  };
  cargoHash = "sha256-DcfKaTv2X/R9m7E74ftBUBAmuvUyBiiPXUMQBgKFCz8=";
  meta.mainProgram = pname;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
