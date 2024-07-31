scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-07-31";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "38c42417b53b21927c6a39b00e650a0356e966e8";
    hash = "sha256-TcxD9ElyWYDu6mECQwtgfAxU9zu2AsCNqXgmSojayPg=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
