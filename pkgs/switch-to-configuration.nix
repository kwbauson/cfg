pkgs: with pkgs; with mylib;
let
  inherit (cfg) nixosConfigurations homeConfigurations;
  hosts = concatMap attrNames [ nixosConfigurations homeConfigurations ];
  eachHost = f: listToAttrs (map (name: { inherit name; value = f name; }) hosts);
  makeNamedScript = name: text: (writeBashBin name
    ''
      set -e
      ${pathAdd [ nix-wrapped coreutils git ] }
      ${text}
    '').overrideAttrs
    (_: { meta.mainProgram = name; });
  makeScript = makeNamedScript "switch";
  profile = name: "/nix/var/nix/profiles/${name}";
  scripts = eachHost (host: rec {
    nos = let conf = nixosConfigurations.${host}; in
      makeScript ''
        if [[ $(realpath ${profile "system"}) != ${conf} ]];then
          sudo nix-env -p ${profile "system"} --set ${conf}
          sudo ${conf}/bin/switch-to-configuration switch
        fi
      '';
    nob = makeScript "sudo ${nixosConfigurations.${host}}/bin/switch-to-configuration boot";
    hms = let conf = homeConfigurations.${host}; in
      makeScript ''
        if [[ $(realpath ${profile "per-user/$USER/home-manager"}) != ${conf} ]];then
          ${conf}/activate
        fi
      '';
    noa = (makeScript ''
      ${optionalString isNixOS (exe nos)}
      ${exe hms}
    '').overrideAttrs (_: { name = "${host}-noa"; });
  });
  makeBin = name: makeNamedScript name ''
    cd ~/cfg
    git add --all
    ${if name == "noa" then ''
    source_path=$(nix eval --raw .#self-source --no-warn-dirty)
    host=$(built-as-host)
    path=$(sed -n "s/$host=//p" output-paths)
    if [[ -n $path ]] && grep -qF "$source_path" output-paths;then
      if nix build --no-link "$path" "$@";then
        exec "$path"/bin/switch
      else
        exec nix run .#$host "$@"
      fi
    fi
    exec nix run .#$host "$@"
    '' else ''
    exec nix run .#switch-to-configuration.scripts.$(built-as-host).${name} "$@"
    ''}
  '';
in
buildEnv {
  inherit name;
  paths = map makeBin (attrNames scripts.${head (attrNames scripts)});
  passthru = { inherit scripts; };
}
