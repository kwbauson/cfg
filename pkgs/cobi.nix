scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-05";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "65b690f3439011524d05e0e612adce59a0db1d4d";
    hash = "sha256-hFhuydeFXhAl8ITLsUfaA9cjBVl11GJW1SfemH7/+Tk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
