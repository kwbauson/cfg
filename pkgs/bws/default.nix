scope: with scope; rustPlatform.buildRustPackage {
  inherit pname;
  version = sources.bitwarden-sdk.rev;
  src = sources.bitwarden-sdk;
  cargoHash = "sha256-MKuTeQafAtoDCBu8LEZiHcPAoGigjc2qQY+195p4XRo=";
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];

  passthru.updateScript = writeBashBin "update-bws" ''
    set -euo pipefail
    cd pkgs/bws
    rev=$(< cargo-hash-rev)
    newRev=${sources.bitwarden-sdk.rev}
    if [[ true || $rev != $newRev ]];then
      hash=$(NIX_PATH=nixpkgs=${pkgs.path} ${exe nix-prefetch} '{ sha256 }: (import ${flake} {}).${pname}.cargoDeps.overrideAttrs (_: { cargoSha256 = sha256; })')
      echo "$newRev" > cargo-hash-rev
      ${getExe nix-editor} default.nix cargoHash -iv "\"$hash\""
    fi
  '';
}
