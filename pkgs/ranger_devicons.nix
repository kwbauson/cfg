scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-06-18";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "1b5780117eeebdfcd221ce45823a1ddef8399848";
    hash = "sha256-MMPbYXlSLwECf/Li4KqYbSmKZ8n8LfTdkOfZKshJ30w=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
