scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2024-02-04";
  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-vscode";
    rev = "975fa04be6493e6468b66815f51b394d6e7e7d6f";
    hash = "sha256-9Xmc8xa75R9wRaJeXuDDT3bLCp6qyfUbS4DnfKDppzY=";
  };
  cargoHash = "sha256-qKG3Q16Q6LO1yYMXtk2q7S7DnEMqq6E/zcNo6lLpIq8=";
  meta.mainProgram = pname;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
