{ _set, scope }: with scope;
{
  inherit (stdenv.hostPlatform) system isLinux isDarwin;
  importNixpkgs = args: cfg.scope.importNixpkgs ({ inherit system; } // args);
  pkgsUnsupported = importNixpkgs { config = c: c // { allowUnsupportedSystem = true; }; };
  pkgsInsecure = importNixpkgs { config = c: c // { allowInsecurePredicate = _: true; }; };
  inherit (bin) fordir;
  callPackage = callPackageWith (pkgs // {
    configdiffNix = cfg.outPath;
    configdiffNixAttr = "configdiff";
  });
  importPackage = arg:
    (attrs: mergeAttrsList [
      attrs
      { name = "${attrs.pname}-${attrs.version or "unstable"}"; }
      (optionalAttrs (attrs ? package) rec {
        type = "derivation";
        package = addMetaAttrs (attrs.meta or { }) attrs.package;
        inherit (package) drvPath outPath out outputName meta;
      })
      (filterAttrs (n: _: elem n [ "package" "__functor" ]) attrs)
      (attrs.passthru or { })
    ]) ((if isFunction arg then fix else id) arg);
  iso = with packages.x86_64-linux; (pkgs.nixos ({ modulesPath, ... }: {
    imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix" ];
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    environment.systemPackages = [ better-comma ];
  })).config.system.build.isoImage;

  alias = name:
    if isString name
    then arg:
      let
        cmd = if isDerivation arg then getExe arg else arg;
        pre = if any (s: hasInfix s arg) [ "&&" "||" ";" "|" "\n" ] then "" else "exec";
        post = if any (s: hasInfix s arg) [ ''"$@"'' "\n" ] then "" else ''"$@"'';
      in
      writeBashBin name "${pre} ${cmd} ${post}"
    else mapAttrs alias name;

  cfgRunner = loc: args: run: (
    let name = last (splitString "." loc); in
    writeBashBin name ''
      set -euo pipefail
      outPath=$(nix build --no-link --print-out-paths --file ${cfg} ${loc}.run ${args})
      exec "$outPath"/bin/run "$@"
    ''
  ).overrideAttrs { passthru.run = args@{ ... }: writeBashBin "run" "exec ${getExe (run args)}"; };

  # for repl inspection
  configs = forAttrs (nixosConfigurations // darwinConfigurations) (name: c:
    c.config // { hm = c.config.home-manager.users.${machines.${name}.username}; }
  );
}
