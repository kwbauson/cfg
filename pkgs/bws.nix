scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-08-01";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "af47c3f550d56db3718f4839e5f29717e399ae4e";
    hash = "sha256-SYPS3+mewwkepKaP2cq3Yrw7M1lHiABYdJqVC6dl65I=";
  };
  cargoHash = "sha256-ZWH4S1b4Z0gOQH1k/r/kB6HZu0vyjmJsolvdNlxtHLo=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  OPENSSL_NO_VENDOR = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
