scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-07-28";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "e401fa2648dd013d9b7ba509ac8b2b0e6cc939fd";
    hash = "sha256-wvUYQWtfMUbQickIIHcsClOr/vNK+yIrd++Qi6RqWy4=";
  };
  cargoHash = "sha256-15GU2tD3V9mmxx8wjs6gN6R+ccndOZaWUHIdqVpORog=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
