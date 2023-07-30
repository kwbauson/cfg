{ self, source, pkgs }: with pkgs.scope; with self.lib; {
  lib = {
    file = f: source + ("/" + f);
    fileExistBools = fs: map pathExists (words fs);
    read = f:
      let p = file f; in optionalString (pathExists p) (readFile p);
    matches =
      { enable ? false
      , files ? ""
      , extraFiles ? ""
      , generated ? ""
      , ...
      }: enable && all (fileExistBools "${files} ${generated}") || any (fileExistBools extraFiles);
  };

  bin = {
    files = "bin";
  };
  nix = {
    extraFiles = "local.nix";
  };
}
