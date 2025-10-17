scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.9.0-unstable-2025-10-06";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "4f9b28373b7c521460b5accd94517ef221bff281";
    hash = "sha256-0N3/zxmnulzM5aXz5nlOr/GWE5rOm3OPb5wFmK1Eeww=";
  };
  cargoHash = "sha256-6VdroqLK4z/bCX8lOaEARlmYJ82qf2x6p+6pp8seSfk=";
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
