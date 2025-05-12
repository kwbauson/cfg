{
  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.g7c.us"
      "https://benaduggan.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.g7c.us:dSWpE2B5zK/Fahd7npIQWM4izRnVL+a4LiCAnrjdoFY="
      "benaduggan.cachix.org-1:BY2tmi++VqJD6My4kB/dXGfxT7nJqrOtRVNn9UhgrHE="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };
}
