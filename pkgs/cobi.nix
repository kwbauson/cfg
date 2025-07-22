scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1917043bce6525d11658acde13166ed5d6a35f34";
    hash = "sha256-2WWH4mCik6AzpJypXR5wpwnBvz6h0T9ElbvUpAbTs1s=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
