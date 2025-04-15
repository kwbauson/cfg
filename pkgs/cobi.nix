scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "80bc4336b840cde32855a871a50680172fbf5b5a";
    hash = "sha256-zv6XVgTfVhoX7vxrTNJmM4QjY8a+6jH99+NrLyKzAT4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
