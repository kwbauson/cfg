scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-09-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "2124a40a5671631929d1c1c0a5c1ed70f35ff835";
    hash = "sha256-ds+yvjcZLr6l0TqLQv4RkMN2GSl8FPaRe2HBas6Q6c8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
