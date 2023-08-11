scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-08-10";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "07cdc6aa5df7b10d0b5c799cafd09a9a3137bc27";
    hash = "sha256-Qq9quz/lVbhIJg2+QUZORvSG4YbnRelRqiH9ZsX1XgA=";
  };
  cargoHash = "sha256-46kLGD5p7leN0mhunnfLNhKz+OD3o6mDCpYKI0TwI5o=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  OPENSSL_NO_VENDOR = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
