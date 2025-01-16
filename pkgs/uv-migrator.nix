scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.4.0-unstable-2025-01-15";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "74f53e2975e4061dba52dc545145ec446447a586";
    hash = "sha256-9vxX09pEIOcZKTvq6Ma+bIgffCWBYK1Na4WHgYidgtk=";
  };
  cargoHash = "sha256-1zmzZd3Xk8b+sTxnLfGPJsVGccMGSCqf5LXqy2K0Ia0=";
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
