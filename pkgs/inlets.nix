pkgs: with pkgs; with mylib; buildGoModule {
  inherit name src;
  vendorSha256 = null;
}
