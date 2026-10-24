scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-10-24";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "442449fa7b1fe6c692d0103ac9fc8f9e82931cf3";
    hash = "sha256-KV+CaZX7QS0hcdKxwGKehDb1jmUgx6lbkTPpaoIW5Nw=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
