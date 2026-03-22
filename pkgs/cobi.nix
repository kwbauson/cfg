scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-03-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a7eb1d8f2a810f31c840ea3a6d091c56c9f0f3a5";
    hash = "sha256-IEHqEzV3ihX7fd1j75lUxGX/+cpeARjgI9LWHKy6q5I=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
