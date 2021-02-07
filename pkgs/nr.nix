pkgs: with pkgs; with mylib;
let
  run-package = writeShellScript "run-package" ''
    package=$1
    shift
    bin=''${PATH//:*}
    if [[ -e $bin/$package ]];then
      exec $bin/$package "$@"
    fi
    shopt -s nullglob
    exes=($bin/*)
    if [[ ''${#exes[@]} = 1 ]];then
      exec "$exes" "$@"
    else
      if [[ ''${#exes[@]} = 0 ]];then
        echo "$package": command not found
      else
        cd "$bin"
        echo "$package": command is ambiguous: *
      fi
      exit 127
    fi
  '';
in
writeShellScriptBin name ''
  ${pathAdd [ nix-wrapped gawk ]}
  [[ $1 == -c ]] && shift && cmd=$1 && shift
  pkg=$1
  shift
  cmd=''${cmd:-$(echo "$pkg" | awk -F. '{ print $NF }')}
  exec nix shell "${selfpkgs.outPath}#$pkg" --command ${run-package} "$cmd" "$@"
'' // {
  __functor = _: exe;
}
