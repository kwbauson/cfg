{ config, scope, ... }: with scope;
let cfg = config.services.olivetin; in
{
  options.services.olivetin = {
    enable = mkEnableOption "olivetin";
    config = types.lines;
  };
  config = mkIf cfg.enable {
    systemd.services.olivetin = {
      wantedBy = [ "multi-user.target" ];
      script =
        let
          olivetin = stdenv.mkDerivation {
            inherit (sources.olivetin) pname version src;
            nativeBuildInputs = [ autoPatchelfHook ];
            inherit (cfg) config;
            passAsFile = "config";
            installPhase = ''
              cp -r . $out
              cp $configPath $out/config.yaml
            '';
          };
        in
        ''
          export "PATH=/run/current-system/sw/bin:$PATH"
          cd ${olivetin}
          exec ./OliveTin
        '';
    };
  };
}
