# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ appdirs, arrow, buildPythonPackage, docopt, fetchPypi, inform, lib, quantiphy
, requests, shlib }:

buildPythonPackage rec {
  pname = "emborg";
  version = "1.32.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kwkp0ky322y371amxgsmh2gvizshgi79dv893d0n6j0xzcflx8h";
  };

  propagatedBuildInputs =
    [ appdirs arrow docopt inform quantiphy requests shlib ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "Borg front end.";
    homepage = "https://emborg.readthedocs.io";
  };
}
