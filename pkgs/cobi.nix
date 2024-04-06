scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-04-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7f69184db10140de37a50c07097e93ecd3640110";
    hash = "sha256-0U82pl8N99Vuq3m3nfNBQUPYbu5tHMU7RkVxCyfLGNs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
