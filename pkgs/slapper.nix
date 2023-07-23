{ buildGoPackage, fetchFromGitHub, nix-update-script }: buildGoPackage {
  pname = "slapper";
  version = "master";
  src = fetchFromGitHub {
    owner = "ikruglov";
    repo = "slapper";
    rev = "8f4421b4adaa8e5ac40a48a010feb7e57020febe";
    hash = "sha256-81x3Rshey43OoWzaVfmfBDSLnpM8FvtnrPTUM6qZ+Bs="; # why not updating
  };
  goPackagePath = "github.com/ikruglov/slapper";
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" "--version" "master" ]; };
}
