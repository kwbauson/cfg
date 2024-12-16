scope: with scope;
let
  python = python3.withPackages (ps: [ ps.typer ps.openai ]);
in
stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ python ];
  installPhase = ''
    mkdir -p $out/bin
    cp ${./main.py} $out/bin/${pname}
    chmod +x $out/bin/${pname}
    patchShebangs $out
    ${optionalString (!isDarwin) ''
    $out/bin/${pname} --show-completion > ${pname}.bash
    installShellCompletion --bash ${pname}.bash
    ''}
  '';
}
