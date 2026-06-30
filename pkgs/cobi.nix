scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1a72fb44d33cc03840e39e55a684167e4749ab7a";
    hash = "sha256-6jiUoG3s5iuj4St+9b9uaC/okYteHwyv5FtFz6lxSpc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
