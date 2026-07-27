scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-07-26";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "78f8757663f3daa44eb8c4f04fa923de7fe992f7";
    hash = "sha256-0yNI8Nl9NRAjjLHmxtqKzvbYLw70YJrziUbGtDZ73cg=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
