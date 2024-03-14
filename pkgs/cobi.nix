scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "dc1a81fb606b5dd4214f96e478db633cb7d03509";
    hash = "sha256-jzasAX/RnNaZRz0dTG3RvkwZlo7aCqEpzf73AesXfME=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
