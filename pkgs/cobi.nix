scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "016e4c60c23445ea204dbb691e6e60d72de43a31";
    hash = "sha256-2/L8mUwVhZo2SVcDQ/JMR15fYu77AP0JfS1/yYgPIHE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
