scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-09-27";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "5efb5a6f4f5ab192817d28557dd4d650fa14d866";
    hash = "sha256-rs9meAYxW3zzrh43yaW7htrqCD+X9+pupDPHN86fumI=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
