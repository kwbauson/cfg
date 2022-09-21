scope: with scope; with python3Packages; buildPythonPackage {
  inherit pname version src;
  propagatedBuildInputs = [ ffmpeg-python tqdm torch more-itertools transformers ];
  doCheck = false;
  postInstall = ''
    wrapProgram $out/bin/${pname} --set PATH ${makeBinPath [ ffmpeg_5-full ]}
  '';
}
