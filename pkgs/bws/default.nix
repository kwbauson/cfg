scope: with scope; rustPlatform.buildRustPackage {
  inherit pname;
  version = sources.bitwarden-sdk.rev;
  src = sources.bitwarden-sdk;
  cargoHash = "sha256-euqcVAN+HSM1u9n9CVI2HRQwnB7KdK274Y/2/qKLNLs=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];

  passthru.updateScript = writeBashBin "update-bws" ''
    set -euo pipefail
    cd pkgs/bws
    rev=$(< cargo-hash-rev)
    newRev=${sources.bitwarden-sdk.rev}
    if [[ $rev != $newRev ]];then
      hash=$(${getExe nix-prefetch} -I nixpkgs=${pkgs.path} '{ sha256 }: (import ${flake} {}).${pname}.cargoDeps.overrideAttrs (_: { cargoSha256 = sha256; })')
      echo "$newRev" > cargo-hash-rev
      ${getExe nix-editor} default.nix cargoHash -iv "\"$hash\""
    fi
  '';
}
