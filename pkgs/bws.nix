scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-07-31";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "b8190e27c77c2b7c51d2f6408a54f66a48993cce";
    hash = "sha256-et+/8H2E3apwCKOPDH/Lqlvv1pObs7OFk/QOkwi3l+Q=";
  };
  cargoHash = "sha256-Z/Sin3UzzNM18d30slBnIxovB5nVv4qunhRzrm7b2xI=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  OPENSSL_NO_VENDOR = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
