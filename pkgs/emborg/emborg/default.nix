# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "emborg";
  version = "1.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19841w7vg1mry60zwsrfij1qc9m4b7ql7jihg9pffc44lb690lcb";
  };

  # TODO FIXME
  doCheck = false;

  meta = with lib; { };
}
