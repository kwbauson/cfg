scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8b30eb4daececadedd21df737572cec978723536";
    hash = "sha256-+MDY0m7YbTW3dfqF95STVnn1ptDylkIKFJxzmQqJQw4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
