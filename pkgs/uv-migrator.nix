scope: with scope;
rustPlatform.buildRustPackage {
  inherit pname;
  version = "2025.8.2-unstable-2025-09-03";
  src = fetchFromGitHub {
    owner = "stvnksslr";
    repo = pname;
    rev = "0f9e6ee3472610a26fcbb50d30fcd5ee74b382a3";
    hash = "sha256-5tNfj/tE0qw+Jx6mU/bi4qm312TmXVvJSRhWQwyEj/o=";
  };
  cargoHash = "sha256-0t18fKYOp6qF+V24tPLK9IUUYp8OTghlT4j3qxqc9kw=";
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
