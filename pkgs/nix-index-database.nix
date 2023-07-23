scope: with scope;
stdenv.mkDerivation {
  name = "nix-index-database";
  inherit pname;
  version = "unversioned";
  src = fetchurl { inherit (sources.nix-index-database) url sha256; };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
}
