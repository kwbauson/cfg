scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-08";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ef55fc5eddc9336fe215625174141e90dcf6c9ac";
    hash = "sha256-HDZ+q6FrGUCq8GsDCUBo0Bdh4HXMDlEn8iZVO0LgaGk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
