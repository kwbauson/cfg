scope: with scope;
(writeBashBin "optionsdoc" ''
  set -euo pipefail
  pathStr=''${1-${if isLinux then "nixos" else "nix-darwin"}}
  MANPATH=$(
    nix build --no-link --print-out-paths --file ${flake} \
      optionsdoc.build --argstr pathStr "$pathStr"
  )
  export MANPATH
  ${getExe man} options
'').overrideAttrs (old: {
  meta = old.meta // { includePackage = true; };
  passthru.build = { pathStr }: rec {
    manualPath = "${nixpkgsPath}/nixos/doc/manual";
    common = import "${manualPath}/common.nix";
    revision = "none";
    path = splitString "." pathStr;
    doc = nixosOptionsDoc {
      inherit revision;
      warningsAreErrors = false;
      options = getAttrFromPath path package.allOptions;
    };
    optionsJSON = doc.optionsJSON.overrideAttrs {
      preferLocalBuild = true;
      allowSubstitutes = false;
    };
    nixos-render-docs = pkgs.nixos-render-docs.overrideAttrs {
      preBuild = ''
        # the script assumes a full options set, but with partial ones we have references to non-included options
        substituteInPlace nixos_render_docs/options.py --replace-fail \
          'self._options_by_id[links[i]]' \
          'self._options_by_id.get(links[i], links[i].lstrip("#opt-"))'
      '';
    };
    result = runCommandLocal "options-man" { } ''
      mkdir -p $out/man5
      file=$out/man5/options.5
      ${getExe nixos-render-docs} -j $NIX_BUILD_CORES options manpage \
        --revision none \
        ${optionsJSON}/${common.outputPath}/options.json \
        $file
      headerStart='\.SH "NAME"'
      headerEnd='^You can use the following options in'
      sed -i \
        -e '1s/"CONFIGURATION.*/"OPTIONS" "5"/' \
        -e "0,/$headerEnd/{/$headerStart/,/$headerEnd/d}" \
        -e '/\.SH "AUTHORS"/,/^Eelco/d' \
        $file
    '';
  }.result;
  passthru = {
    allOptions = fix (self: {
      nixos = (inputs.nixpkgs.lib.nixosSystem {
        modules = [{
          nixpkgs = { inherit pkgs; };
          system.stateVersion = "FAKE";
        }];
      }).options;
      no = self.nixos;
      home-manager = (inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ options, ... }: {
            home.stateVersion = last options.home.stateVersion.type.functor.payload.values;
            home.username = "FAKE";
            home.homeDirectory = "/FAKE";
          })
        ];
      }).options;
      hm = self.home-manager;
      nix-darwin = (inputs.nix-darwin.lib.darwinSystem {
        modules = [{
          nixpkgs = { inherit pkgs; };
        }];
      }).options;
      nd = self.nix-darwin;
      tfn = (tfn.build { configPath = ../terraform/config.nix; }).unsanitized.options;
    } // mapAttrs (_: c: c.options) (nixosConfigurations // darwinConfigurations));
  };
})
