scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-01-11";
  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "9197bbf397d76059a76310523d45df10d2e4ca81";
    hash = "sha256-sJM82Sj8yfQYs9axEmGZ9Evzdv/kDcI9sddqJ45frrU=";
  };
  passthru.updateScript = unstableGitUpdater { };
})
