scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-20";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "95bd3058b82e079aa022910eb28c3cfb38109c1e";
    hash = "sha256-BMnUvB7cIy0VCbrJ/KlkHX9NaT4vElEMnYG/BukHN5U=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
