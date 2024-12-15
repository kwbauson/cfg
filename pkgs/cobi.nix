scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-15";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a526637e285bf59c8940cb371a64b486141098f1";
    hash = "sha256-PhmQ3OfN2xCSJYYVa6Cpvln+Bi48txpJZNN1k9I0624=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
