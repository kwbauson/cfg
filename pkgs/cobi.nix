scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "6704078edaf3be3c6974bc137b0719fdc263275c";
    hash = "sha256-M+Z64Vi9SzLtLHm+W7BRJ6/GG6LBEProUuzWAb87aBI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
