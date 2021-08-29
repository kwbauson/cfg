pkgs: with pkgs; with mylib; latestWrapper name (stdenv.mkDerivation {
  inherit name;
  script = ''
    #!/usr/bin/env bash
    ${pathAdd [ gnused coreutils fzy nix-wrapped nr ]}
    set -e
    [[ $1 = -u ]] && uncache=1 && shift
    [[ $1 = -d ]] && desc=1 && shift
    cmd=$1
    if [[ -z $cmd || $cmd = -h || $cmd = --help ]];then
      echo usage: , COMMAND ARGS
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
      cachefile=~/.cache/${name}/$cmd
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
        exec nix eval --impure --expr "with import ${self-source}; desc $attr"
      else
        if [[ -z $packages ]];then
          exec nr "$cmd" "$@"
        else
          exec nr -c "$cmd" "$attr" "$@"
        fi
      fi
    fi
  '';
  completion = ''
    _${name}()
    {
        local cur prev opts exes PATH
        ${pathAdd [ gnused coreutils ]}
        COMPREPLY=()
        cur="''${COMP_WORDS[COMP_CWORD]}"
        prev="''${COMP_WORDS[COMP_CWORD-1]}"

        if [[ $COMP_CWORD = 1 ]] || [[ $prev = -* && $COMP_CWORD = 2 ]];then
          # sql="select distinct name from Programs where name like '$cur%' order by name"
          exes=$(sed -En "s/^[^ ]+ ($cur.*)$/\1/p" ${nix-index-list} | sort)
          COMPREPLY=( $(compgen -W "$exes" -- "$cur") )
        else
          COMPREPLY=( $(compgen -f -- "$cur") )
        fi
        return 0
    }
    complete -F _${name} better-comma
    complete -F _${name} ,
  '';
  passAsFile = [ "script" "completion" ];
  dontUnpack = true;
  nativeBuildInputs = [ installShellFiles ];
  installPhase = ''
    mkdir -p $out/bin
    cp $scriptPath $out/bin/${name}
    chmod +x $out/bin/${name}
    ln -s $out/bin/{${name},","}
    installShellCompletion --bash --name better-comma $completionPath
    installShellCompletion --bash --name , $completionPath
  '';
})
