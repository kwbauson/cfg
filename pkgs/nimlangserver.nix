scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-08-24";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "85c1b32fc1fb28552cc45f5cf8ca005ae345e1e9";
    hash = "sha256-nZ2iGFjczpt9+4uE/3y6SGyjMoQgSsF+dGJ/8XIjs/0=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
