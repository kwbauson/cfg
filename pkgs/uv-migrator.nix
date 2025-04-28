scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.7.1-unstable-2025-04-26";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "72ff406e5a0ef9ce5329716c5059bd515b4036fb";
    hash = "sha256-c6MDHjXL+fTzya5BD0WhgtIpTHRrAfwYjJ1wWS3f+Ws=";
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
