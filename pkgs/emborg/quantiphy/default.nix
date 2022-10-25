# WARNING: This file was automatically generated. You should avoid editing it.
# If you run pynixify again, the file will be either overwritten or
# deleted, and you will lose the changes you made to it.

{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "quantiphy";
  version = "2.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rhdymr8rd30n91b602mkq14s03fzl8ilai1lz772c9wm2zlm8gc";
  };

  # TODO FIXME
  doCheck = false;

  meta = with lib; {
    description = "physical quantities (numbers with units)";
    homepage = "https://quantiphy.readthedocs.io";
  };
}
