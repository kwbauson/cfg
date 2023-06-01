scope: with scope; rustPlatform.buildRustPackage {
  inherit pname;
  version = sources.bitwarden-sdk.rev;
  src = sources.bitwarden-sdk;
  cargoHash = (fromJSON (readFile ./cargo.json)).hash;
  buildAndTestSubdir = "crates/bws";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ optionals isDarwin [ darwin.Security ];

  passthru.updateScript = writeBashBin "update-bws" ''
    set -euo pipefail
    cd pkgs/bws
    rev=$(${exe jq} -r .rev < cargo.json)
    newRev=${sources.bitwarden-sdk.rev}
    if [[ $rev != $newRev ]];then
      hash=$(NIX_PATH=nixpkgs=${pkgs.path} ${exe nix-prefetch} '{ sha256 }: (import ${flake} {}).${pname}.cargoDeps.overrideAttrs (_: { cargoSha256 = sha256; })')
      ${exe jo} -p rev="$newRev" hash="$hash" -o cargo.json
    fi
  '';
}
