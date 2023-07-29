scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-07-27";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "c970cf9a3e009218977be7d09ee9fe33d3697f97";
    hash = "sha256-87AEVpta8vAqiUFYZ8SEPy2iDTz29vgibyjTxX6bJ3c=";
  };
  cargoHash = "sha256-tYrGaOkaQkqQF6EOQ9tdwHN+hXs/cm5pnXBMweM7r4w=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
