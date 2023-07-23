scope: with scope; rustPlatform.buildRustPackage rec {
  inherit pname;
  version = "master";
  # src = sources.bitwarden-sdk;
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = version;
    sha256 = "";
  };
  cargoHash = "sha256-NgwJSPL5N8/QlaS6LDGLjtr5HeHRGBUCOc21EHN5nGM=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" "--version" "master" ]; };
}
