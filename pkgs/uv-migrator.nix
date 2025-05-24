scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.8.0-unstable-2025-05-23";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "0ef4e4240c09dc1fb45c408d7b0314eeab7efe39";
    hash = "sha256-VvgMhzmkr6mI3WRIGLKcBi18SZO9Oqcv/zuU/WC+pDk=";
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
