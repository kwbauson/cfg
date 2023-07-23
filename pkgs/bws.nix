scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "bws-v0.2.1";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "0654e2727c238aef3728ca86cca7427d4a8dd4f2";
    sha256 = "sha256-NgwJSPL5N8/QlaS6LDGLjtr5HeHRGBUCOc21EHN5nGM=";
  };
  cargoHash = "";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];

  # passthru.updateScript = unstableGitUpdater { };
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; };
  # passthru.updateScript = _experimental-update-script-combinators.sequence [
  #   (unstableGitUpdater { })
  #   (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  # ];
  # passthru.updateScript = writeShellScript "update" (concatMapStringsSep "\n" (concatStringsSep " ") [
  #   (unstableGitUpdater { })
  #   (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  # ]);
}
