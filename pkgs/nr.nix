pkgs: with pkgs; with mylib;
(writeBashBin name ''
  ${pathAdd nix-wrapped}
  [[ $1 == -c ]] && shift && cmd=$1 && shift
  pkg=$1
  shift
  cmd=''${cmd:-''${pkg//*.}}
  exec nix shell "${self-source}#$pkg" --command "$cmd" "$@"
'').overrideAttrs (attrs: { passthru.__functor = _: exe; })
