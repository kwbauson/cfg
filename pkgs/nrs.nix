scope: with scope;
addMetaAttrs { includePackage = true; } ((writeBashBin pname ''
  if [[ $1 = -p ]];then
    shift
    pkg=$1 && shift
    cmd=$1 && shift
    exec nix shell "${self-flake}#$pkg" --command "$cmd" "$@"
  else
    pkg=$1 && shift
    exec nix run "${self-flake}#$pkg" -- "$@"
  fi
'').overrideAttrs (attrs: { passthru.__functor = _: exe; }))
