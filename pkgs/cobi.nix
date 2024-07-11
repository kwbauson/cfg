scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b4956a59949fe2075c0fa0d3367683295b595434";
    hash = "sha256-u1R6P4SV6nUQl9PG78ryu/sUL50hSFqBrqJL6KyjASw=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
