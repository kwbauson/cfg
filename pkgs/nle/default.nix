scope: with scope;
let
  build = let nixpkgs = pkgs; in
    { path, pkgs ? nixpkgs, source ? null }:
    import ./nix-local-env.nix { inherit pkgs path source; };
in
(build { path = ./.; }).overrideAttrs (_: {
  name = "nle";
  passthru = { inherit build; };
  passthru.test.default = nle.build { path = writeTextDir "meme" ''meme''; };
})
