scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-08-02";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "1f6856aaec505c6a62350746c828f12d39c436af";
    hash = "sha256-mrpSmWc2fttnr33zVuo7ugWXyegZaolUnEVXEWIEKt4=";
  };
  cargoHash = "sha256-0BzfMaT7CqgEBXTBFlQrv53hBI9iUktjB+kJn4SMk9U=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  OPENSSL_NO_VENDOR = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
