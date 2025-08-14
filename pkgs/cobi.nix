scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-08-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f1363629f1f95cf77ac90fff72647bbce810ef6c";
    hash = "sha256-dBNL6eggdMmtVgD3E4UYatyHlvphNsz256ihiBoYW2s=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
