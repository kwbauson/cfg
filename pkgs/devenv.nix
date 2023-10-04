scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-10-03";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "05e26941f34486bff6ebeb4b9c169b6f637f1758";
    hash = "sha256-cfGsdtDvzYaFA7oGWSgcd1yST6LFwvjMcHvtVj56VcU=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
