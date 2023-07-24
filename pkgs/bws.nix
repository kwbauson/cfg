scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-07-24";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "37033dfd14d05a15a1c356ce91ff7abb70842f9b";
    hash = "sha256-u0+JG6REqEDiso+X6+PSBZwEmkxYi3mO0EgJtEpKeow=";
  };
  cargoHash = "sha256-Gau0VUI5bQKk38SrQgYsF1HMwGDN+Tq+/10HOuYHm1M=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
