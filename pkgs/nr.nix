pkgs: with pkgs; with mylib; writeShellScriptBin name ''
  ${pathAdd [ nix-wrapped gawk ]}
  pkg=$1
  shift
  cmd=$(echo "$pkg" | awk -F. '{ print $NF }')
  exec nix shell "${selfpkgs.outPath}#$pkg" --command "$cmd" "$@"
'' // {
  __functor = _: exe;
}
