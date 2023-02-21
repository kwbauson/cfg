{ scope, ... }: with scope;
let
  olivetin = stdenv.mkDerivation {
    inherit (sources.olivetin) pname version src;
    nativeBuildInputs = [ autoPatchelfHook ];
    config = ''
      listenAddressSingleHTTPFrontend: localhost:${toString constants.olivetin.port}
      actions:
        - title: Restart Jitsi
          icon: "&#128577;"
          shell: systemctl restart prosody jitsi-meet-init-secrets jicofo jitsi-videobridge2
          timeout: 10

        - title: Reboot Server
          icon: "&#128683;"
          shell: reboot
    '';
    passAsFile = "config";
    installPhase = ''
      cp -r . $out
      cp $configPath $out/config.yaml
    '';
  };
in
{
  systemd.services.olivetin = {
    wantedBy = [ "multi-user.target" ];
    script = ''
      export "PATH=/run/current-system/sw/bin:$PATH"
      cd ${olivetin}
      exec ./OliveTin
    '';
  };
}
