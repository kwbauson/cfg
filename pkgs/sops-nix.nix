scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-11-16";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "7c637afdccdf9bcf35c4a2d67b58a77c1fd843a4";
    hash = "sha256-Y28AMB8lyKjASdJ0BVsR2AqR1cUsVuo8RVVpzHoECho=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
