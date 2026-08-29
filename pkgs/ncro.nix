scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "2.2.2-unstable-2026-08-29";
  src = fetchFromGitHub {
    owner = "manic-systems";
    repo = pname;
    rev = "b9510ba652f7435876ad45d374105c882172a1c4";
    hash = "sha256-Cv89mgobOP7jG8Cn7uSDSzL6S7TzH/OTu3nNJc0OQHg=";
  };
  package = callPackage "${attrs.src}/nix/package.nix" { };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
