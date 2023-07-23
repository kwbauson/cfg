scope: with scope;
clipnotify.overrideAttrs (_: {
  version = "unstable-2022-11-08";
  src = fetchFromGitHub {
    owner = "cdown";
    repo = pname;
    rev = "25ba143c7da8ae0f196cb0db2797d30e6d04e15c";
    hash = "sha256-m0Ji48cRp4mvhHeNKhXTT4UDK32OUYoMoss/2yc7TDg=";
  };
  passthru.updateScript = unstableGitUpdater { };
})
