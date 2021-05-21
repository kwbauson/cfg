pkgs: with pkgs; with mylib;
let
  inherit (cfg) nixosConfigurations homeConfigurations;
  hosts = concatMap attrNames [ nixosConfigurations homeConfigurations ];
  eachHost = f: listToAttrs (map (name: { inherit name; value = f name; }) hosts);
  makeNamedScript = name: text: (writeBashBin name
    ''
      set -e
      ${pathAdd [ nix-wrapped coreutils git nvd ] }
      ${text}
    '').overrideAttrs
    (_: { meta.mainProgram = name; });
  makeScript = makeNamedScript "switch";
  scripts = eachHost
    (host: rec {
      nob = let conf = nixosConfigurations.${host}; in
        makeScript ''
          sudo nix-env -p /nix/var/nix/profiles/system --set ${conf}
          sudo ${conf}/bin/switch-to-configuration boot
        '';
      nos = let conf = nixosConfigurations.${host}; in
        makeScript ''
          if [[ $(realpath /run/current-system) != ${conf} ]];then
            nvd diff /run/current-system ${conf}
            sudo nix-env -p /nix/var/nix/profiles/system --set ${conf}
            sudo ${conf}/bin/switch-to-configuration switch
          fi
        '';
      hms = let conf = homeConfigurations.${host}; in
        makeScript ''
          hm_path=$(nix-env -q home-manager-path --out-path --no-name)
          if [[ $hm_path != ${conf.config.home.path} ]];then
            nvd diff $hm_path ${conf.config.home.path}
            ${conf}/activate
          fi
        '';
      noa = (makeScript ''
        ${optionalString isNixOS "${exe nos} || true"}
        ${exe hms}
      '').overrideAttrs (_: { name = "${host}-noa"; });
    }) // { unknown.noa = null; };
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
