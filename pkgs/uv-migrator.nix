scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.8.1-unstable-2025-06-06";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "b8da54f4554810949439e21573813f0545f75d85";
    hash = "sha256-SzO9Z2y7LQ+AE90pGN734Z+0FOa3mcDeI7KMKqoWW4o=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-DsK8hDftdkVxxWuxCa8iHCDsD7huQAomj2fMSA7LjOY=";
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
