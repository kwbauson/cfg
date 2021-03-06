pkgs: with pkgs; with mylib;
(writeBashBin name ''
  ${pathAdd nix-wrapped}
  if [[ $1 == -c ]];then
    shift && cmd=$1 && shift
    pkg=$1 && shift
    exec nix shell "${self-source}#$pkg" --command "$cmd" "$@"
  else
    pkg=$1 && shift
    exec nix run "${self-source}#$pkg" -- "$@"
  fi
'').overrideAttrs (attrs: { passthru.__functor = _: exe; })
