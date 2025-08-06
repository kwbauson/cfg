scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6c2dbf5ef73a8f08f8358764d441509ae217a4af";
    hash = "sha256-saqQBGO4G6wZG9T1xjMFAid+WuZDs70UQAg4kJeibEY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
