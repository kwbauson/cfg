scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-04-26";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "97ffd6da89c658abaf6043e29ac6aeab1afda8f9";
    hash = "sha256-juZofxcb+D7mTVVKHcrPf/d8/udkWG8EKzMtTEXSyqo=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
