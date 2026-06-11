scope: with scope;
let
  machines-json = writeJSON "machines.json" (mapAttrValues (getAttrs [ "system" "username" ]) machines);
in
addMetaAttrs { includePackage = true; } (writeBashBin pname ''
  set -euo pipefail
  ${pathAdd [ age sops jq ]}
  target=''${1-}
  machine=$(machine-name)
  keysPath=~/.config/sops/age/keys.txt
  secretsFile=~/cfg/machines/$machine/secrets.yaml
  remoteSecretsFile=/tmp/${pname}-remote.yaml
  if [[ $target = '--remote' ]];then
    secretsFile=$remoteSecretsFile
  fi
  if [[ $target = '--remote-done' ]];then
    cat "$remoteSecretsFile"
    unlink "$remoteSecretsFile"
    exit 0
  elif [[ -n $target && $target != '--remote' ]];then
    targetUsername=$(jq -r ".\"$target\".username" ${machines-json})
    read targetSystem targetUsername < <(jq -r '[."'"$target"'".["system", "username"]] | @tsv' ${machines-json})
    sshTarget="$targetUsername@$target"
    nixCopy() {
      nix copy --no-check-sigs --to ssh-ng://"$sshTarget" "$@"
    }
    if [[ ${system} = $targetSystem ]];then
      out=${placeholder "out"}
      nixCopy "$out"
      remoteBin=$out/bin/${pname}
    else
      nixCopy ${cfg}
      remoteBin=$(ssh "$sshTarget" 'nix build --no-link --print-out-paths ${cfg}#${pname}')/bin/${pname}
    fi
    resultFile=~/cfg/machines/$target/secrets.yaml
    if [[ -e $resultFile ]];then
      scp -q "$resultFile" "$sshTarget":"$remoteSecretsFile"
    fi
    ssh -t "$sshTarget" "bash -lc '$remoteBin --remote'"
    ssh "$sshTarget" "$remoteBin --remote-done" > $resultFile
    exit 0
  fi
  if [[ ! -e $keysPath ]];then
    echo 'generating new encryption key'
    mkdir -p "$(dirname "$keysPath")"
    age-keygen -pq --output "$keysPath"
  fi
  if [[ ! -e $secretsFile ]];then
    echo 'creating new secrets file'
    echo 'hello: world' > $secretsFile
    sops encrypt --in-place --age "$(age-keygen -y "$keysPath")" "$secretsFile"
  fi
  sops edit "$secretsFile" || true
'')
