scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-07-22";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "def76d0ba0d3743bdfa3a8fdb3903e0928b3c6f0";
    hash = "sha256-6C6ASG6E0GaXU2THdcNy4SZgQDHE/QC0suh40KXUaWU=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
