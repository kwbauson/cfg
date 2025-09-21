scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-21";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "204a72a27f8928a938b2a1e47b4d62eb66e0453a";
    hash = "sha256-1j48e9IW8fm16OJ3UEOU255k7z1GtpYasiEd4g/XvQ0=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
