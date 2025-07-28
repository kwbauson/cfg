scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d16ec27729c93425aed6e4ea3166e28669b0de52";
    hash = "sha256-qLu/MPfb8UYTLmpUKlclDRUHwzhPAhDZ37Q7ayBK3hA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
