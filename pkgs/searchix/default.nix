scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0.1.38-unstable-2025-05-09";
  src = fetchgit {
    url = "https://codeberg.org/alanpearce/searchix.git";
    rev = "dae1f9319556516fb10ef6bfe2058690639c1891";
    hash = "sha256-D0qkde1cyGWD7nzsYIzyp/SmERd8BAF1sCs+Elf8cr0=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  flake = compatGetFlake attrs.src;
  package = compatGetFlakeDefault attrs.src;
})
