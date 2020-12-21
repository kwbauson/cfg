pkgs: with pkgs; with mylib; buildEnv rec {
  inherit name;
  paths = [
    (
      (
        writeShellScriptBin ","
          ''
            ${pathAdd [ sqlite coreutils fzy nix-wrapped ]}
            set -e
            [[ $1 = -u ]] && uncache=1 && shift
            [[ $1 = -d ]] && desc=1 && shift
            cmd=$1
            if [[ -z $cmd || $cmd = -h || $cmd = --help ]];then
              echo usage: , COMMAND ARGS
              exit
            fi
            sql="select distinct package from Programs where name = '$cmd'"
            packages=$(sqlite3 -init /dev/null ${programs-sqlite} "$sql" 2> /dev/null)

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
            if [[ -n $attr ]];then
              if [[ $desc = 1 ]];then
                exec nix eval --impure --expr "with import ${selfpkgs.outPath}; desc $attr"
              else
                exec nix shell "${selfpkgs.outPath}#$attr" --command "$@"
              fi
            fi
          ''
      ).overrideAttrs (_: { inherit name; })
    )
    (
      writeTextDir "etc/bash_completion.d/${name}.sh"
        ''
          _${name}()
          {
              ${pathAdd [ sqlite ]}
              local cur prev opts sql
              COMPREPLY=()
              cur="''${COMP_WORDS[COMP_CWORD]}"
              prev="''${COMP_WORDS[COMP_CWORD-1]}"
              sql="select distinct name from Programs where name like '$cur%' order by name"

              if [[ $COMP_CWORD = 1 ]] || [[ $prev = -* && $COMP_CWORD = 2 ]];then
                COMPREPLY=( $(compgen -W "$(sqlite3 -init /dev/null ${programs-sqlite} "$sql" 2> /dev/null)" -- "$cur") )
              else
                COMPREPLY=( $(compgen -f -- "$cur") )
              fi
              return 0
          }
          complete -F _${name} ,
        ''
    )
  ];
}
