scope: with scope; stdenv.mkDerivation {
  inherit pname version;
  script = ''
    #!/usr/bin/env bash
    ${pathAdd [ gnused coreutils fzy nix-wrapped ]}
    set -eo pipefail
    overlays=()
    while [[ $1 = --overlay ]];do
      shift
      overlays+=("$1")
      shift
    done
    [[ $1 = -u ]] && uncache=1 && shift
    [[ $1 = -d ]] && desc=1 && shift
    if [[ ''${#overlays[@]} -eq 0 ]];then
      source=${self-source}
    else
      contents=
      for file in "''${overlays[@]}";do
        contents+=$(< "$file")
      done
      hash=($(echo "${self-source} $contents" | md5sum))
      source=~/.cache/${pname}/$hash
      if [[ ! -e $source ]];then
        mkdir -p "$source"
        cp -rT ${self-source} "$source"
        mkdir -p "$source"/extra-overlays
        for file in "''${overlays[@]}";do
          cp "$file" "$source"/extra-overlays
        done
      fi
    fi
    if [[ $1 = -p ]];then
      shift
      pkg=$1 && shift
      cmd=$1 && shift
      exec nix shell "$source#$pkg" --command "$cmd" "$@"
    fi
    cmd=$1
    if [[ -z $cmd || $cmd = -h || $cmd = --help ]];then
      echo usage: , [--overlay FILE ...] [-p package] COMMAND [ARGS]
      exit
    fi
    shift
    packages=$(sed -En "s/^([^ ]+) $cmd$/\1/p" ${nix-index-list})

    if [[ $(echo "$packages" | wc -l) = 1 ]];then
      if [[ -z $packages ]];then
        attr=$cmd
      else
        attr=$packages
      fi
    else
      cachefile=~/.cache/${pname}/$cmd
      [[ -n $uncache ]] && rm -f "$cachefile"
      if [[ -e $cachefile ]];then
        attr=$(< "$cachefile")
      else
        attr=$(echo "$packages" | fzy)
        mkdir -p "$(dirname "$cachefile")"
        echo "$attr" > "$cachefile"
      fi
    fi
    mkdir -p ~/.local/share/nix
    if [[ -n $attr ]];then
      if [[ $desc = 1 ]];then
        exec nix eval --impure --expr "with import $source; desc $attr"
      else
        if [[ -z $packages ]];then
          exec nix shell "$source#$cmd" --command "$cmd" "$@"
        else
          exec nix shell "$source#$attr" --command "$cmd" "$@"
        fi
      fi
    fi
  '';
  completion = ''
    _${pname}()
    {
        local cur prev opts exes PATH
        compopt +o default
        ${pathAdd [ gnused coreutils ]}
        COMPREPLY=()
        cur="''${COMP_WORDS[COMP_CWORD]}"
        prev="''${COMP_WORDS[COMP_CWORD-1]}"

        if [[ $COMP_CWORD = 1 ]] || [[ $prev = -* && $COMP_CWORD = 2 ]];then
          exes=$(sed -En "s/^[^ ]+ ($cur.*)$/\1/p" ${nix-index-list} | sort)
          COMPREPLY=( $(compgen -W "$exes" -- "$cur") )
        else
          compopt -o default
          COMPREPLY=()
        fi
        return 0
    }
    complete -F _${pname} better-comma
    complete -F _${pname} ,
  '';
  passAsFile = [ "script" "completion" ];
  dontUnpack = true;
  nativeBuildInputs = [ installShellFiles ];
  installPhase = ''
    mkdir -p $out/bin
    cp $scriptPath $out/bin/${pname}
    chmod +x $out/bin/${pname}
    ln -s $out/bin/{${pname},","}
    installShellCompletion --bash --name better-comma $completionPath
    installShellCompletion --bash --name , $completionPath
  '';
}
