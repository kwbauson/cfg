scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5c75cec26ba63b468fbd6a159f37a7531187e94b";
    hash = "sha256-84pkkqzfyYsSBd90OWhwuey6uKdQBgxaVPw9+ZKUHxI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
