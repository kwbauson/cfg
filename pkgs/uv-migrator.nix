scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.6.0-unstable-2025-02-03";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "f68b29d1d4afc4ba1b1d9a25d355d07759d44997";
    hash = "sha256-E4WoQFeyTK0BzBrDJS/9ob9CCSPzjFkZly6JBtmJBMg=";
  };
  cargoHash = "sha256-lAbZljyEWEWzW0cjydvnu4OwTVbaukw2YH2gd7aYZJY=";
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
