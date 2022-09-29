scope: with scope; rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoSha256 = "FAz1txkKye+99VtcjSBTpffHa4t5owIOwzr5qX3A6ww=";
  nativeBuildInputs = [ nix ];
  CFG_REV = src.rev;
}
