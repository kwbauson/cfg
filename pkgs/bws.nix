scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-07-25";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "ae1cd7d113f07414e7ecd4818a610baabe646266";
    hash = "sha256-YLAo7VJhX9hb1dmwA0UOZtRjFsxUHq0J87YHw84gGcg=";
  };
  cargoHash = "sha256-ZbPyWBUROrD14UvZoLyksdnKRICyf56gK48VDtPwEQk=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
