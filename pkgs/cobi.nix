scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-06-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4ce672c193b0dbece88018db015ea04ccfc0aa60";
    hash = "sha256-azaKUInzKwcsQAE4XmhDt5Uo5+ipDD5CC1VaYlGkGY4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
