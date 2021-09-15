{ pkgs, ... }:
{
  environment.etc."foo".source = with pkgs; with mylib; stdenv.mkDerivation {
    pname = "olivetin";
    version = sources.olivetin.version;
    src = sources.olivetin;
    nativeBuildInputs = [ autoPatchelfHook ];
    config = ''
      listenAddressSingleHTTPFrontend: localhost:1337
      logLevel: "INFO"
      actions:
        - title: Reboot Server
          shell: reboot

        - title: Restart Jitsi
          shell: systemctl restart jitsi-meet-init-secrets jitsi-videobridge2 jitsi-videobridge
    '';
    passAsFile = "config";
    installPhase = ''
      mkdir -p $out/share
      cp -r . $out/share/olivetin
      cp $configPath $out/share/olivetin/config.yaml
    '';
  };
}
