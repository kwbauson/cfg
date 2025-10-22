scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a90775795c001b2b5a07af42e36a62f5bfe9d634";
    hash = "sha256-wOFqObhUUk2s0Fjrek5MMVPm9PH9Fjd4yCYTU5nWEqc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
