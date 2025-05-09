scope: with scope;
addMetaAttrs { includePackage = true; } (writeBashBin pname ''
  if [[ $1 = --delete-booted-system ]];then
    echo sudo rm -f {/nix/var/nix/gcroots,/run}/booted-system
  fi
  find {/nix/var,~/.local/state}/nix/profiles -not -type d |
    sort |
    sed -En 's/^(.*)-([0-9]+)-link$/\0 \1 \2/p' |
    while read link profile generation;do
      realLink=$(realpath "$link")
      if [[ $realLink = $(realpath "$profile") ]];then
        echo "skipping $profile generation $generation because it is current generation"
      elif [[ $realLink = $(realpath /run/booted-system) ]];then
        echo "skipping $profile generation $generation because it is booted system"
      else
        [[ -O $link ]] && prefix= || prefix=sudo
        echo "deleting $profile generation $generation"
        $prefix nix-env --quiet --quiet --profile "$profile" --delete-generations "$generation"
      fi
    done
'')
