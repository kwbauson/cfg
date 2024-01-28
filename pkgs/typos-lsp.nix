scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2024-01-17";
  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-vscode";
    rev = "389d2e03de5cab1f61ff89a135290a6a98bc7bb4";
    hash = "sha256-ijduf9Ao+1YJXZnsnbB+/W6Pa7m2kcuC3asCbTzPLQs=";
  };
  cargoHash = "sha256-t7kjlrjLZ8Pks8iCp/GZ2saI7BDzLS4gwDW8bTuj1qg=";
  meta.mainProgram = pname;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
