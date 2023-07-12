scope: with scope;
let
  cobi-nix = fetchTree { type = "github"; owner = "jpetrucciani"; repo = "nix"; rev = "541d8f7c774159310ec53b2e1de4cc639c134f95"; };
  pog = (import cobi-nix { inherit nixpkgs system; }).pog;
in
pog {
  name = "clip";
  description = "Utility to sync clipboards across hosts.";
  flags = mapAttrsToList (name: mergeAttrs { inherit name; short = ""; }) {
    sync_primary = {
      description = "Listens and syncs the primary selection to the clipboard when the clipboard changes.";
      bool = true;
    };
    server = {
      description = "Server mode to accept clipboard contents from other hosts.";
      bool = true;
    };
    port = {
      description = "Port for server mode on all hosts.";
      default = "6543";
    };
    selection = {
      description = "Which clipboard to send to other hosts.";
      default = "primary";
    };
    hosts = {
      description = "Comma separated list of hosts to send clipboard to.";
      default = "";
    };
    poll_time = {
      description = "Polling time to check for clipboard changes on MacOS.";
      default = "5s";
    };
  };
  script = h: ''
    set -euo pipefail
    ${pathAdd [ xsel clipnotify netcat-gnu coreutils util-linux ]}
    isDarwin=${boolToString isDarwin}
    IFS=, read -ra hosts_array < <(echo "$hosts")
    send_to_hosts() {
      contents=$1
      for host in "''${hosts_array[@]}";do
        printf %s "$contents" | nc "$host" "$port" || true
      done
    }
    if ${h.flag "sync_primary"};then
      while read -r;do
        xsel --output --clipboard | xsel --input --primary
      done < <(clipnotify -s clipboard -l)
    elif ${h.flag "server"};then
      echo Listening on "$port" and sending "$selection" contents to "$hosts"
      state=$(mktemp --tempdir clip-server-XXXXX)
      touch "$state"/{clip,port}
      listen_port() {
        while :;do
          contents=$(nc -lp "$port")
          uuidgen > "$state"/port
          if [[ $isDarwin = true ]];then
            printf %s "$contents" | pbcopy
          else
            printf %s "$contents" | xsel --input --"$selection"
          fi
        done
      }
      listen_clip() {
        if [[ $isDarwin = true ]];then
          prev_contents=$(pbpaste)
          while sleep "$poll_time";do
            contents=$(pbpaste)
            if [[ "$prev_contents" != "$contents" ]];then
              if [[ "$(< "$state"/clip)" != "$(< "$state"/port)" ]];then
                uuidgen > "$state"/clip
                send_to_hosts "$contents"
                prev_contents=$contents
              fi
            fi
          done
        else
          while read -r;do
            if [[ "$(< "$state"/clip)" != "$(< "$state"/port)" ]];then
              contents=$(xsel --output --"$selection")
              uuidgen > "$state"/clip
              send_to_hosts "$contents"
            fi
          done < <(clipnotify -s "$selection" -l)
        fi
      }
      on_exit() {
        rm -rf "$state"
        kill -- -"$port_pid" -"$clip_pid" 2> /dev/null
      }
      trap on_exit EXIT
      listen_port & port_pid=$!
      listen_clip & clip_pid=$!
      wait
    else
      if [[ $isDarwin = true ]];then
        if [[ -t 0 ]];then
          pbpaste
        else
          pbcopy
        fi
      else
        xsel --"$selection"
      fi
    fi
  '';
}
