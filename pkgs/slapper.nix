pkgs: with pkgs; with mylib; buildGoPackage {
  inherit name src;
  goPackagePath = "github.com/ikruglov/slapper";
}
