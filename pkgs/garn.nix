scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-03";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "41703e980a1b3f60748dc6202660f7241cf31a4e";
    hash = "sha256-mLbxctUD5qMoSoIwCICXG/JUbGmSUkLkRmz5Ypqelho=";
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
