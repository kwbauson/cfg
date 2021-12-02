scope: with scope;
(writeBashBin pname ''
  ${pathAdd nix-wrapped}
  if [[ $1 = -p ]];then
    shift
    pkg=$1 && shift
    cmd=$1 && shift
    exec nix shell "${self-source}#$pkg" --command "$cmd" "$@"
  else
    pkg=$1 && shift
    exec nix run "${self-source}#$pkg" -- "$@"
  fi
'').overrideAttrs (attrs: { passthru.__functor = _: exe; })
