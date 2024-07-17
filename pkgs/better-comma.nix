scope: with scope; stdenv.mkDerivation {
  inherit pname version;
  script = ''
    #!/usr/bin/env bash
    ${pathAdd [ gnused coreutils fzy ]}
    set -o pipefail
    overlays=()
    while [[ $1 = --overlay ]];do
      shift
      overlays+=("$1")
      shift
    done
    [[ $1 = -u ]] && uncache=1 && shift
    [[ $1 = -d ]] && desc=1 && shift
    [[ $1 = -m ]] && man=1 && shift
    if [[ ''${#overlays[@]} -eq 0 ]];then
      source=${self-flake}
    else
      contents=
      for file in "''${overlays[@]}";do
        contents+=$(< "$file")
      done
      hash=($(echo "${self-flake} $contents" | md5sum))
      source=~/.cache/${pname}/$hash
      if [[ ! -e $source ]];then
        mkdir -p "$source"
        cp -rT ${self-flake} "$source"
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
    fi
    cmd=$1
    shift
    if [[ -z $cmd || $cmd = -h || $cmd = --help ]];then
      echo usage: , [--overlay FILE ...] [-p package] COMMAND [ARGS]
      exit
    fi
    if [[ -z $pkg ]];then
      packages=$(sed -En "s/^([^ ]+) $cmd$/\1/p" ${nix-index-list})
      if [[ $(echo "$packages" | wc -l) = 1 ]];then
        if [[ -z $packages ]];then
          pkg=$cmd
        else
          pkg=$packages
        fi
      else
        cachefile=~/.cache/${pname}/$cmd
        [[ -n $uncache ]] && rm -f "$cachefile"
        if [[ -e $cachefile ]];then
          pkg=$(< "$cachefile")
        else
          pkg=$(echo "$packages" | fzy)
          mkdir -p "$(dirname "$cachefile")"
          echo "$pkg" > "$cachefile"
        fi
      fi
    fi
    if [[ -z $pkg ]];then
      pkg=$cmd
    fi

    mkdir -p ~/.local/share/nix
    if [[ $desc = 1 ]];then
      exec nix eval --impure --raw --expr "with import $source { forceFlakeCompat = false; }; descString $pkg + \"\n\""
    elif [[ $man = 1 ]];then
      exec nix shell "$source#$pkg" --command man "$cmd" "$@"
    else
      exec nix shell "$source#$pkg" --command "$cmd" "$@"
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
