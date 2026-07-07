scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4687d6a7e628d87930413a89e1ec655fb29d8e6a";
    hash = "sha256-scomE8yQYzI990ocYi9DCfUDkJN5Z6MnpKVLg2g/dmc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
