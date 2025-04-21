scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-04-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d4a48be90c4a829953c97fb57a9d12099bbb9164";
    hash = "sha256-kz5MfTJDOtIZHaPyZCpCHeY3CchwU95m4hsH0pj2+iA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
