scope: with scope; rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoSha256 = "6Iwdmmdz12DaMAJ5bdZ2CkDHbWDv7uyCrQmAfUVcIn0=";
  nativeBuildInputs = [ nix ];
  CFG_REV = src.rev;
}
