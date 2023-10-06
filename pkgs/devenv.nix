scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-10-06";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "bd859ef4b207c2071f5bd3cae2a74f4d3e69c2e2";
    hash = "sha256-PzVHnPnm+aceuQOoE3oExjHSxiLFAEiHFyQb3xXCI1c=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
