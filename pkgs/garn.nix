scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-04";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "29c9a64ba080281734a80198e27db6ec97239b83";
    hash = "sha256-++a9FFeMEK5W7iQTkOAdrM7tP9sD2WRWkKv9k/3xIKk=";
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
