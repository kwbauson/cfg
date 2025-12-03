scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6e634db33e42b5b156a75249973a82dd01c1c07d";
    hash = "sha256-Mxjlnab5cLYT+aQUgtCFSSvGQYK6BMa33up3eZXji0c=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
