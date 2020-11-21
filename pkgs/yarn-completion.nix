pkgs: with pkgs; stdenv.mkDerivation {
  inherit name src;
  nativeBuildInputs = [ installShellFiles ];
  installPhase = "installShellCompletion --name yarn $src/${name}.bash";
}
