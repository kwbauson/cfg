scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f1574379cb0fbc85ac2d6a58760f56ceeecdf147";
    hash = "sha256-ZshxRpnk23++q4snoYo9BulYlJ4hHZRybiSH6KWOvyU=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
