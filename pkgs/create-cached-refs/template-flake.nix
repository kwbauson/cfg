{
  outputs = { self }:
    let
      # see https://github.com/NixOS/nixpkgs/blob/master/lib/attrsets.nix
      genAttrs = names: f: builtins.listToAttrs (map (n: { name = n; value = f n; }) names);
      # see https://github.com/NixOS/nixpkgs/blob/master/lib/systems/flake-systems.nix
      systems.flakeExposed = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "armv6l-linux"
        "armv7l-linux"
        "i686-linux"
        "aarch64-darwin"
        "powerpc64le-linux"
        "riscv64-linux"
        "x86_64-freebsd"
      ];
      mkPath = builtins.storePath;
    in
    {
      packages = genAttrs systems.flakeExposed (system: import ./default.nix { inherit system mkPath; });
      apps = genAttrs systems.flakeExposed (system:
        builtins.mapAttrs (name: path: { type = "app"; program = path + "/bin/${name}"; }) self.packages.${system}
      );
    };
}
