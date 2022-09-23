scope: with scope; with python3Packages; callPackage ./emborg {
  quantiphy = callPackage ./quantiphy { };
  shlib = callPackage ./shlib { };
}
