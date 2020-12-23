pkgs: with pkgs; with mylib; writeShellScriptBin name ''
  ${pathAdd [ nix-wrapped gawk ]}
  [[ $1 == -c ]] && shift && cmd=$1 && shift
  pkg=$1
  shift
  cmd=''${cmd:-$(echo "$pkg" | awk -F. '{ print $NF }')}
  exec nix shell "${selfpkgs.outPath}#$pkg" --command "$cmd" "$@"
'' // {
  __functor = _: exe;
}
