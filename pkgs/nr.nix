pkgs: with pkgs; with mylib;
let
  run-package = writeShellScript "run-package" ''
    cmd=$1
    shift
    bin=''${PATH//:*}
    if [[ -e $bin/$cmd ]];then
      exec $bin/$cmd "$@"
    fi
    shopt -s nullglob
    exes=($bin/*)
    if [[ ''${#exes[@]} = 1 ]];then
      exec "$exes" "$@"
    else
      if [[ ''${#exes[@]} = 0 ]];then
        echo "$cmd": command not found
      else
        cd "$bin"
        echo "$cmd": command is ambiguous: *
      fi
      exit 127
    fi
  '';
  nr =
    writeShellScriptBin name ''
      ${pathAdd nix-wrapped}
      [[ $1 == -c ]] && shift && cmd=$1 && shift
      pkg=$1
      shift
      cmd=''${cmd:-''${pkg//*.}}
      exec nix shell "${selfpkgs.outPath}#$pkg" --command ${run-package} "$cmd" "$@"
    '';
in
nr.overrideAttrs (attrs: { passthru.__functor = _: exe; })
