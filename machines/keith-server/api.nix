{ config, scope, ... }: with scope;
{
  systemd.services.personal-api = {
    script = writePython3Bin "personal-api" { libraries = [ python3.pkgs.fastapi ]; } ''
    '';
  };
}
