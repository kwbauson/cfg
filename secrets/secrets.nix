{ scope ? (import ../. { }).scope }: with scope;
let
  keys = mapAttrs (_: m: m.public-key) machines;
  mkRules = mapAttrs' (n: v: nameValuePair "${n}.age" (if isString v || isList v then { publicKeys = toList v; } else v));
in
with keys;
mkRules {
  cachix-dhall = {
    publicKeys = [ keith-desktop keith-xps keith-server readlee-mac-m1 ];
    isUserSecret = true;
  };
  test = [ keith-desktop keith-server ];
  test2 = keith-desktop;
  test3 = {
    publicKeys = [ keith-desktop ];
    owner = "keith";
  };
  test4 = [ keith-desktop keith-server ];
}
