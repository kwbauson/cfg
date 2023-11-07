scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-06";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "7a0bcf4c20bd1e978c0f3cd44bc3b3cb7b90f4b3";
    hash = "sha256-tzgpPKgRLWiS6TZkJzZH+WzogVMEpmxHtmG9oXZ99Gc=";
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
