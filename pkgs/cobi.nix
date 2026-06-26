scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-06-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ac1d600e42e23433a554f17fd937d0801bb9adc5";
    hash = "sha256-woEj8ufct05IU4W09WFmux6oKaEkK5tj6qLBKtlcwv4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
