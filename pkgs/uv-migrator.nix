scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.3.4-unstable-2025-01-07";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "292a0dd4e3518ebe6a2114a843d1de97c9ed1423";
    hash = "sha256-6c7vxnX0LYhFEZrno2aTQTzHW7fSll2mQV8oXPRekYM=";
  };
  cargoHash = "sha256-IRzqKfgWqD1Jvr6WwtjUr3OEMC1IizQPSD9VbdxlnQY=";
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
