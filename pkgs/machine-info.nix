scope: with scope;
{ machine }:
let
  paths = [
    "name"
    "system"
    "username"
    [ "tailscale" "ip" ]
    [ "tailscale" "fqdn" ]
  ];
  mkCond = p: concatStringsSep " && " (imap (i: n: ''''$${toString i} = ${n}'') p);
in
pipe paths [
  (map toList)
  (filter (p: hasAttrByPath p machine))
  (map (p: ''
    if [[ ${mkCond p} && ! -v ${toString (length p + 1)} ]];then
      echo ${getAttrFromPath p machine}
      exit 0
    fi
  ''))
  (concatStrings)
  (s: s + "exit 1")
  (writeBashBin "machine")
]
