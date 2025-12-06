scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a59e1508e7b569481d4a8d1cf3445fec025c9bbb";
    hash = "sha256-AFweiaim9AZjVFtotnnSZ3HRntokGJUxOXWiEbzge8w=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
