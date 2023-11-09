scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-08";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "36b09f7a7a925bb80722f51459ceec80a3803cee";
    hash = "sha256-QaLdeilzygMMNpjRPDW3OVqWfBLO/ahGRWIMp/hZvKQ=";
  };
  package = (haskellPackages.callPackage "${attrs.src}/garn.nix" { }).overrideAttrs (old: {
    doCheck = false;
    nativeBuildInputs = old.nativeBuildInputs ++ [ makeWrapper ];
    postFixup = ''
      ${old.postFixup or ""}
      wrapProgram $out/bin/garn --prefix PATH : ${makeBinPath [ deno ]}
    '';
  });
  passthru.updateScript = unstableGitUpdater { };
})
