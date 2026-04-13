scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c3de0daeba636d1e23458ca531eccf01a087b9f5";
    hash = "sha256-9eqrOyBERDq9GWQz5aGB8E6tcYTeDjBUyt4je9iMZx4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
