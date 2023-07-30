scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-07-28";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "a5217c887954f4e69aad377d52253efefbc0b2b8";
    hash = "sha256-YupmXUxrwOyEwmlCvGfx4+3qbPmwaA9ebObENyp+2g4=";
  };
  cargoHash = "sha256-15GU2tD3V9mmxx8wjs6gN6R+ccndOZaWUHIdqVpORog=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  OPENSSL_NO_VENDOR = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
