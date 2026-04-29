scope: with scope;
let
  plugins = [ "github.com/greenpau/caddy-security@v1.1.62" ];
in
(caddy.withPlugins {
  inherit plugins;
  hash = "sha256-+p2yLB945GejAE/JVr0quOHn2U3UT4UUmJ6tyzQvpHs=";
}).overrideAttrs (old: {
  meta = old.meta // {
    skipBuild = isDarwin;
  };
  passthru = old.passthru // rec {
    tests = { };
    updaterText = /* bash */ ''
      set -euo pipefail
      ${pathAdd gnused}
      pkgFile=pkgs/${pname}.nix
      changed=
      for refWithVersion in ${toString plugins};do
        old=$(echo "$refWithVersion" | sed 's/.*@//')
        ref=$(echo "$refWithVersion" | sed 's/@.*//')
        new=$(${getExe lastversion} --format tag "https://$ref")
        if [[ $new != $old ]];then
          changed=true
          echo "$ref" "$old" "$new"
          sed -i "s;$refWithVersion;$ref@$new;" "$pkgFile"
        fi
      done
      if [[ $changed = true ]];then
        echo updating hash
        nixOutput=$(nix build .#${pname}.src 2>&1 || true)
        oldHash=$(echo "$nixOutput" | sed -En 's/\s*specified: (\S+)$/\1/p')
        newHash=$(echo "$nixOutput" | sed -En 's/\s*got: (\S+)$/\1/p')
        sed -i "s;$oldHash;$newHash;" "$pkgFile"
      fi
    '';
    updater = writeBashBin "updater" updaterText;
    updateScript = [ (getExe updater) ];
  };
})
