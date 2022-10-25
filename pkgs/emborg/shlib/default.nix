# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ braceexpand, buildPythonPackage, fetchPypi, inform, lib, pytest-runner }:

buildPythonPackage rec {
  pname = "shlib";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bri60ypcm6zyzhz75qivq6dq96yj14070zzpc90135k81nckv84";
  };

  buildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ braceexpand inform ];

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "shell library";
    homepage = "https://nurdletech.com/linux-utilities/shlib";
  };
}
