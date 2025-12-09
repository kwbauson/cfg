scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.9.0-unstable-2025-12-07";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "46387e99a9b65e7ca99839abb4db004ff0b656a9";
    hash = "sha256-mLlb98vcc6Wcq094/r54ZpLlWGs+ah28zqfwNCxikGg=";
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
