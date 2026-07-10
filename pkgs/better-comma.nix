scope: with scope;
stdenvNoCC.mkDerivation {
  inherit pname version;
  preferLocalBuild = true;
  allowSubstitutes = false;
  dontUnpack = true;
  passAsFile = [ "script" "completion" ];
  script = ''
    #!${getExe bash}
    ${pathAdd [ gnused coreutils fzy ]}
    set -eo pipefail
    source=${cfg}
    [[ $1 = -u ]] && uncache=1 && shift
    [[ $1 = -d ]] && desc=1 && shift
    [[ $1 = -m ]] && man=1 && shift
    [[ $1 = --trace ]] && trace=1 && shift
    [[ $1 = -p ]] && shift && pkg=$1 && shift
    cmd=$1
    if [[ $trace = 1 ]];then
      set -x
    fi
    shift
    if [[ -z $cmd || $cmd = -h || $cmd = --help ]];then
      echo 'usage: , [OPTIONS] COMMAND [ARGS]'
      echo '  -p package      explicitly specify package'
      echo '  -d command      print info about package containing command'
      echo '  -u command      clear cached info about command'
      echo '  -m command      open man-page for command'
      exit
    fi
    cachedir=~/.cache/"${pname}"
    cachefile=$cachedir/$cmd
    if [[ $uncache = 1 && -e $cachefile ]];then
      unlink "$cachefile"
    fi
    cached=
    if [[ -e $cachefile ]];then
      read pkg storePath cacheSource < "$cachefile"
      if [[ $source = $cacheSource && -e $storePath ]];then
        cached=1
      fi
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
        pkg=$(echo "$packages" | fzy)
      fi
    fi

    if [[ ! -e ~/.local/share/nix ]];then
      mkdir -p ~/.local/share/nix
    fi
    if [[ $desc = 1 ]];then
      echo "$pkg"
      exec nix eval --impure --raw --expr "with import $source {}; descString $pkg + \"\n\""
    fi
    if [[ $cached != 1 ]];then
      storePath=$(nix build --no-link --print-out-paths "$source#$pkg.outPath")
      if [[ ! -e $cachedir ]];then
        mkdir -p "$cachedir"
      fi
      echo "$pkg $storePath $source" > "$cachefile"
    fi
    export PATH="$PATH":"$storePath"/bin
    if [[ $man = 1 ]];then
      exec man "$cmd" "$@"
    else
      exec "$cmd" "$@"
    fi
  '';
  completion = /* bash */ ''
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
  nativeBuildInputs = [ installShellFiles ];
  installPhase = ''
    mkdir -p $out/bin
    cp $scriptPath $out/bin/${pname}
    chmod +x $out/bin/${pname}
    ln -s $out/bin/{${pname},","}
    installShellCompletion --bash --name better-comma $completionPath
    installShellCompletion --bash --name , $completionPath
  '';
  passthru.checkScript = /* bash */ ''
    , -p hello hello
    , -d hello
  '';
  meta.includePackage = true;
}
