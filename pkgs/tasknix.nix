scope: with scope;
let
  flakeNix = toFile "tasknix-flake-nix" ''
    {
      outputs = { self, nixpkgs }: {
        packages = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all (system:
          with nixpkgs.legacyPackages.''${system}; with builtins;
          mapAttrs writers.writeBashBin (scopedImport pkgs ./tasks.nix)
        );
      };
    }
  '';
  flakeLock = toFile "tasknix-flake-lock" ''
    {
      "nodes": {
        "nixpkgs": {
          "locked": {
            "narHash": "${inputs.nixpkgs.narHash}",
            "path": "${inputs.nixpkgs.outPath}",
            "type": "path"
          },
          "original": {
            "id": "nixpkgs",
            "type": "indirect"
          }
        },
        "root": {
          "inputs": {
            "nixpkgs": "nixpkgs"
          }
        }
      },
      "root": "root",
      "version": 7
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
    workdir=$(${coreutils}/bin/mktemp --tmpdir -d tasknix.XXXXX)
    trap '${coreutils}/bin/rm -rf "$workdir"' EXIT
    echo "$(< ${flakeNix})" > "$workdir"/flake.nix
    echo "$(< ${flakeLock})" > "$workdir"/flake.lock
    echo "$(< tasks.nix)" > "$workdir"/tasks.nix
    ${nix}/bin/nix --extra-experimental-features 'nix-command flakes' run --no-update-lock-file "$workdir"#"$task" -- "$@"
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp "$scriptPath" $out/bin/tasknix
    chmod +x $out/bin/tasknix
    ln -s $out/bin/{tasknix,t}
  '';
}
