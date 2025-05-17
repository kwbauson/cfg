scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-17";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "321ee3ab13413e37bb64764539809b1811c7557c";
    hash = "sha256-6X+PG6OtbuT33RWbTJo4z9gg9i++ww1rE/kH6EzMkZs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
