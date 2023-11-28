scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-27";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "15ce7ff68631d0dc3e73411fc266ec2c38355084";
    hash = "sha256-InufK0bQx6UxIdXHo4czG7z+aGwG4oi8CNN7B1h4wo4=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
