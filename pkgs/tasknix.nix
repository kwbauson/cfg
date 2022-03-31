scope: with scope;
let flakeNix = toFile "tasknix-base-flake" ''
  {
    inputs.nixpkgs.url = "path:${pkgs.path}";
    outputs = { self, nixpkgs }: {
      packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (system:
        builtins.mapAttrs nixpkgs.legacyPackages.''${system}.writers.writeBashBin (import ./tasks.nix)
      );
    };
  }
'';
in
stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  passAsFile = "script";
  script = ''
    #!/usr/bin/env bash
    if [[ ! -e tasks.nix ]];then
      echo no tasks.nix
      exit 1
    fi
    task=$1
    shift
    if [[ -z $task ]];then
      echo missing task name
      exit 1
    fi
    ${pathAdd [ nix coreutils ]}
    cachedir=''${XDG_CACHE_HOME:-$HOME/.cache}/tasknix
    [[ -d $cachedir ]] || mkdir -p "$cachedir"
    echo "$(< ${flakeNix})" > "$cachedir"/flake.nix
    echo "$(< tasks.nix)" > "$cachedir"/tasks.nix
    exec nix --extra-experimental-features 'nix-command flakes' run "$cachedir"#"$task" -- "$@"
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp "$scriptPath" $out/bin/tasknix
    chmod +x $out/bin/tasknix
    ln -s $out/bin/{tasknix,l}
  '';
}
