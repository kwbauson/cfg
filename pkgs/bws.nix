scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-08-08";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "8ffe940acac8328a4a146fa33f88db4318b78a43";
    hash = "sha256-iAtCnQy7ZYTWE7+Eyb0JIBAV6IQ8pvh+EizCc5DNKYQ=";
  };
  cargoHash = "sha256-3jDdqB49P+ge7kICBzgROSJgh7XPGQSxjvvvvPOMdsI=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  OPENSSL_NO_VENDOR = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
