scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.7.1-unstable-2025-03-25";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "5633d49581241d0a80ca819e2043983872ffdb50";
    hash = "sha256-vxnSRtDy5mtQkd4FtDOdNyFDlrWNFnbWlznccXUnL/Q=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-qHMtVFdRgfpXqivb45JWvmV1WrWPocAos1sI0GQF7so=";
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
