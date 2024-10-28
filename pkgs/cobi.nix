scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ce73050da30d8a7ec6c6befb56c219866083a56e";
    hash = "sha256-dLfpidh+eXMvDBOoMzZRmFhTOnmajpCD9YH2bpZnKnk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
