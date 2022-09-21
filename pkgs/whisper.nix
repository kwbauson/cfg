scope: with scope; with python3Packages; buildPythonPackage rec {
  inherit pname version src;
  propagatedBuildInputs = [ ffmpeg-python tqdm torch more-itertools transformers ];
  doCheck = false;
}
