scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7e85858b2179c352c7f13660c127942f7ced1cb6";
    hash = "sha256-MYlRZym+eNhO7A5Q8mjbxTqI7LfNO1mp8EgoBiZyb88=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
