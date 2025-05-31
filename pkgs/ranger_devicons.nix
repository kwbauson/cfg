scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-05-30";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "4498496b29bbba38cc6f0f0c83ec23d96b00f122";
    hash = "sha256-vVuPEYeNtP6H71yyvpN9JWY6Lg01j6a3bsSdYn7VgRg=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
