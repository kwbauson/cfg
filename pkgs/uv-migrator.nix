scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.3.3-unstable-2025-01-02";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "042f2f4e88b2fca83cdfaf880fddb1a47263f55f";
    hash = "sha256-cLx3sk45o45/SIcAPoM+Eu02+EZbSiIy7Ef6FthezFo=";
  };
  cargoHash = "sha256-kJ8PiOVkNDCStkvy/6xuydIwcQXiK4qJNWZNU7dV9lQ=";
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
