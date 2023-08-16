scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-15";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "5c258eec1f7497aa9ec0b8aa85931dcde6925a9f";
    hash = "sha256-uQKYKEKtdJJzJl1wn/hmUrNjFe6HMETF1GUlKcCOHZw=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
