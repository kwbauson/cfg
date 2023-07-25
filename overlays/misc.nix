final: prev: with final.scope; {
  nix = nixUnstable;
  nixOld = prev.nix;
  nix-wrapped = wrapBins nix ''
    mkdir -p ~/.local/share/nix
    export NIX_CONFIG=$(< ${writeText "nix.conf" nixConfBase})$'\n'$NIX_CONFIG
    exec "$exePath" "$@"
  '';
  nix-index-list = stdenv.mkDerivation {
    name = "nix-index-list";
    extra =
      let
        extraPackages = set: concatMapStringsSep "\n" (n: "${set}.${n} ${n}") (attrNames (pkgs.${set}));
        extra-set-list = concatMapStringsSep "\n" extraPackages
          [ "nodePackages" "python3Packages" "rubyPackages" ];
        base-list = concatMapStringsSep "\n" (n: "${n} ${n}") (attrNames pkgs);
      in
      base-list + extra-set-list;
    passAsFile = "extra";
    dontUnpack = true;
    buildInputs = [ nix-index ];
    installPhase = ''
      nix-locate  \
        --db ${nix-index-database} \
        --at-root \
        --type x --type s \
        --regex '/bin/[^.][^/]*' |
        grep -v '^(' |
        awk '{ print $1, $4 }' |
        sed -E 's#^(.*)\.\w+ .*/([^/]+)$#\1 \2#' > list
      sort list $extraPath | uniq > $out
    '';
  };
  steam-native = steam.override { nativeOnly = true; };
  dejavu_fonts_nerd = nerdfonts.override { fonts = [ "DejaVuSansMono" ]; };
  nle-cfg = nle.build { path = ../.; };
  inherit (nle-cfg.pkgs) fordir;
  inherit (nle-cfg.pkgs.poetry-env.python.pkgs) git-remote-codecommit;
  self-flake-lock = runCommand "self-flake-lock" { nativeBuildInputs = [ jq moreutils ]; } ''
    cp ${self-source}/flake.lock $out
    chmod +w $out
    entries=$(jq '.nodes.root.inputs | to_entries' $out)
    inputs_keys=$(jq -r '.[].key' <<<"$entries")
    inputs_values=$(jq -r '.[].value' <<<"$entries")
    if [[ $inputs_keys != $inputs_values ]];then
      echo invalid input mapping
      jq '.nodes.root.inputs' $out
      echo generated flake.lock of self does not support nested inputs
      exit 1
    fi
    self_inputs="${concatStringsSep "\n" (attrNames inputs)}"
    self_inputs=$(echo "$self_inputs" | sort)
    lock_inputs=$(jq -r '.nodes | keys | sort[]' $out | grep -vFx root)
    if [[ $inputs_keys != $lock_inputs ]];then
      echo self_inputs: $self_inputs
      echo lock_inputs: $lock_inputs
      echo inputs of self do not match flake.lock nodes
      exit 1
    fi
    self_inputs="${concatStringsSep "\n" (mapAttrsToList (n: v: "${n} ${v.outPath} ${v.narHash}") inputs)}"
    echo "$self_inputs" | while read input outPath narHash;do
      jq ".nodes.\"$input\".locked = { type: \"path\", path: \"$outPath\", narHash: \"$narHash\" }" $out | sponge $out
    done
  '';
  self-flake = runCommand "self-flake" { } ''
    cp -r ${self-source} $out
    chmod -R +w $out
    cp ${self-flake-lock} $out/flake.lock
  '';
  iso = with packages.x86_64-linux; (nixos ({ modulesPath, ... }: {
    imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix" ];
    nixpkgs.config.allowUnfree = true;
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
  })).config.system.build.isoImage;
  sourcesInfo = pipe ../flake.lock [
    readFile
    unsafeDiscardStringContext
    fromJSON
    (x: x.nodes)
    (filterAttrs (name: _: name != "root"))
    (mapAttrValues (x: { inherit (x.locked) owner repo rev; }))
  ] // pipe extra-packages [
    (filterAttrs (_: pkg: pkg ? src.rev))
    (mapAttrValues (pkg: { inherit (pkg.src) owner repo rev; }))
  ];
}
