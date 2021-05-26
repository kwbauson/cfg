pkgs: with pkgs; rustPlatform.buildRustPackage {
  inherit name src;
  cargoPatches = [ ./Cargo.lock.patch ];
  cargoHash = "sha256-Y2ruzA3HNNBJq0j2SygRqL0JKoNI9tWejZfrLSsIt6c=";
  doCheck = false;
}
