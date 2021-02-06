pkgs: with pkgs; with mylib; buildGoModule {
  inherit name src;
  vendorSha256 = "dSqiKviuzVlDtGR5ziM6MieRMok73AGRXUNyamrIySA=";
  checkPhase = ":";
  postInstall = ''
    mv $out/bin/{cmd,juicefs}
  '';
}
