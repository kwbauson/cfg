scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e5c5359a57154e06315c62f7efb173c1f53dec4a";
    hash = "sha256-wxO/K70Pn8bo/BV1aJ6tncZUmPv4dmWdyBz49fRUUTY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
