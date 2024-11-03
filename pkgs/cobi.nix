scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-11-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "edd0ea4dcd15e941b5f2af431737b5d848165278";
    hash = "sha256-22G82eAN4BbpKdEmwPM4QKzk9iCE2YxJUaO4Otvvmf4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
