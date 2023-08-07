scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-2023-08-07";
  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "sdk";
    rev = "ba21624e25e85e89dd1868dee17cdb04f89ebe5c";
    hash = "sha256-HqR3me+aOwvdncnLVf02TKpUM1z+YXUrTj/ZeoblEMg=";
  };
  cargoHash = "sha256-EKE30jxCpaueDjQeRtSJlvKIfoC7x6RE7zG7emQUpTs=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];
  OPENSSL_NO_VENDOR = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
