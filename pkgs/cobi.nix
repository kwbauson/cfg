scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-24";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d1cd3248c9e2704b98d2c52e1b3749d2e21aced8";
    hash = "sha256-+HfQ4zn2GMTd5YDfQxPl6SXWSZwRTWQrdhiSXkLL634=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
