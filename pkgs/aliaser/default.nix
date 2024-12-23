scope: with scope;
stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];
  addPath = makeBinPath [ jq yaml2json toml2json ];
  installPhase = ''
    mkdir -p $out/bin
    cd $out/bin
    cp ${./aliaser} ${pname}
    wrapProgram $out/bin/${pname} --prefix PATH : "$addPath"
    ln -s ${pname} a
  '';
  meta.mainProgram = pname;
  passthru.__functor = _: config:
    let
      jsonFile = writeText "aliases.json" (toJSON config);
      script = writeBash "aliaser-script" ''
        cmd=$(basename "$0")
        ${getExe aliaser} --config ${jsonFile} "$cmd" "$@"
      '';
    in
    stdenv.mkDerivation {
      name = "aliaser-scripts-bin";
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        ${concatMapStringsSep "\n" (n: "ln -s ${script} $out/bin/${n}") (attrNames config)}
      '';
    };
}
