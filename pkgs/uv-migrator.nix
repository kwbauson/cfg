scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.1.0-unstable-2024-12-14";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "88e26d82fc9244a76464dd355bfd31826f0069e6";
    hash = "sha256-sVhNF4bL/zsZvXX+JnHOwkKvBHmzy+iFFRBLBl6zfu8=";
  };
  cargoHash = "sha256-va/qLJdD+NGLz8oQRUsjlo7okbaaAqla3Jn5FabzO6M=";
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/uv-migrator --prefix PATH : ${makeBinPath [ uv_050 ]}
  '';
  meta.mainProgram = pname;
  meta.platforms = platforms.linux;
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (unstableGitUpdater { tagPrefix = "v"; })
    (nix-update-script { extraArgs = [ "--flake" "--version" "skip" ]; })
  ];
}
