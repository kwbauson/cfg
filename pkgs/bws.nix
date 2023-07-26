scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-07-26";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "5c5d5d087eefd7b318da57b43d00ae731bd6131f";
    hash = "sha256-o+tmO9E881futhA/fN6+EX2yEBKnKUmKk/KilIt5vYY=";
  };
  cargoHash = "sha256-MwaXGRxSWEKQmFhKgEKszr6L2jtUQadN/fbEFrctGwk=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
