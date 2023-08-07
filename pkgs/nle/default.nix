scope: with scope;
let
  build = let nixpkgs = pkgs; in
    { path, pkgs ? nixpkgs, source ? null }:
    import ./nix-local-env.nix { inherit pkgs path source; };
in
(build { path = writeTextDir "bin/nle" (readFile ./nle); }).overrideAttrs (_: {
  name = "nle";
  passthru = { inherit build; };
  passthru.tests.default = nle.build { path = writeTextDir "meme" ''meme''; };
})
