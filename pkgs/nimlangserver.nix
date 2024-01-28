scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-27";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "4979bb060951675ddb74a1ac1076debd3b45b44f";
    hash = "sha256-Xk90xJi8R+uRO24gIehfuAB30Dq4uspRlazE0NZC47g=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
