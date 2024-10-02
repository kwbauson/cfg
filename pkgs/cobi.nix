scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "41b181f63e2c7f5f00c78075cbaebdb9bcb40464";
    hash = "sha256-0c6e8L2yJG9cdDz1jX1koIX6yiF8vfBYabeizAoZclM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
