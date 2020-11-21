{ pkgs ? import <nixpkgs> { }, ... }: with pkgs;
writeShellScriptBin "," ''
  cmd=$1
  db=$(nix-instantiate --eval --expr '<nixpkgs>')/programs.sqlite
  sql="select distinct package from Programs where name = '$cmd'"
  packages=$(${sqlite}/bin/sqlite3 -init /dev/null "$db" "$sql" 2> /dev/null)

  if [[ $(echo "$packages" | wc -l) = 1 ]];then
    if [[ -z $packages ]];then
      echo "$cmd": command not found
      exit 127
    else
      attr=$packages
    fi
  else
    attr=$(echo "$packages" | ${fzy}/bin/fzy)
  fi
  if [[ -n $attr ]];then
    exec ${nixUnstable}/bin/nix --experimental-features 'nix-command = nix-flakes' \
      shell -f ${toString path} "$attr" --command "$@"
  fi
''
