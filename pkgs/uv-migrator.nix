scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.7.1-unstable-2025-02-27";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "f2c414461dc4801a5964e81fd04b04721104c113";
    hash = "sha256-Xkp/SVIIUfXSUga70M4Vy8rusFG0m2ClTN0ezwvHIU8=";
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
