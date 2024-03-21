scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4f29955ee0ef83ceaa1ba6bdfff9f0a271b4d9a9";
    hash = "sha256-56RPgHPhu6+DpcWCklgkrOs+Knlpfo1C4lTANq4VtvI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
