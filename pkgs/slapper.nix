scope: with scope; buildGoPackage {
  inherit pname version src;
  goPackagePath = "github.com/ikruglov/slapper";
}
