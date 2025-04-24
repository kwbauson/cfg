scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "02d0af77790dcfadbd6be23d6025dd45d101987c";
    hash = "sha256-9wSOJJnWPPK0sbqxCeoAaNcNkdTznJFYNzLorazBOPM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
