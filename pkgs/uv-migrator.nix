scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.7.0-unstable-2025-02-25";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "56b34a8093b29fbd80e80cd1f6d18211ac41f67b";
    hash = "sha256-kC1qYvXZVPK+8FMMZ6st0Egr2qSiThQOTgzBnIQ7LwE=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-ITfH2U61cC2h0h4RKcASTfi9oBONjjQNJtDU9M2mK8s=";
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/uv-migrator --prefix PATH : ${makeBinPath [ uv_050 ]}
  '';
  meta.mainProgram = pname;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { tagPrefix = "v"; })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
