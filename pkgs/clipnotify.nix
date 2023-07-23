scope: with scope;
clipnotify.overrideAttrs (_: {
  version = "unstable-2022-11-08";
  src = fetchFromGitHub {
    owner = "cdown";
    repo = pname;
    rev = "18a36bc57c77e88b684da0485510fd69ae47b593";
    hash = "sha256-dQzoH4+SHv1+RRWtfqNARp9qiQvg+54bY4HSw423mFk=";
  };
  passthru.updateScript = unstableGitUpdater { };
})
