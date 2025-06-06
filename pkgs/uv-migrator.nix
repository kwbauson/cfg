scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.8.0-unstable-2025-06-05";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "968d60d36565b6e69a10d5aefb92a50865111723";
    hash = "sha256-7UeNw4V6CdcpJocyrmI8JiwKOj2xWJSC2/pJz48k1WY=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-bdBgijlRMMzsORgeB1Qv/8yF/z5mfwvtnG5bSQD7MoU=";
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/uv-migrator --prefix PATH : ${makeBinPath [ uv_050 ]}
  '';
  meta.mainProgram = pname;
  meta.skipBuild = true;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { tagPrefix = "v"; })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
