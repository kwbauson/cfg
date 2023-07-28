scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-07-28";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "2f1ea12120982c6288aeb5616f787b6727923b89";
    hash = "sha256-rcoWxhoQr+GmDmeG6N7q8NW0+o8rUgj4hKpyZHhziUk=";
  };
  cargoHash = "sha256-1g9hvTZJFLFrSZa/I61/W6trT+R5A+GZ8be4MzL+igs=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
