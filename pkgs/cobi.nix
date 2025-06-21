scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-06-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0ce1884cc20038d4e4dd32deb4241c8817a7bf49";
    hash = "sha256-l0hwI+1okgmIXwZKtUxXspDAxQeatAVcXzXxvKb6Gpo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
