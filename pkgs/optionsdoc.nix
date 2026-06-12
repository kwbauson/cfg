scope: with scope;
(writeBashBin "optionsdoc" ''
  set -euo pipefail
  pathStr=''${1-${if isLinux then "nixos" else "nix-darwin"}}
  exec nix shell "SELF_REF.run.$pathStr._run" -c options-man
'').overrideAttrs (finalAttrs: previousAttrs:
let inherit (finalAttrs) passthru; in with passthru; {
  SELF_REF = "${cfg}#optionsdoc";
  content = /* bash */ ''
    ${replaceString "SELF_REF" finalAttrs.SELF_REF previousAttrs.content}
    # keep render package in closure ${nixos-render-docs}
  '';
  meta = previousAttrs.meta // { includePackage = true; };
  # this assumes a full options set, but with partial ones we have references to non-included options
  passthru.nixos-render-docs = pkgs.nixos-render-docs.overrideAttrs {
    preBuild = ''
      substituteInPlace nixos_render_docs/options.py --replace-fail \
        'self._options_by_id[links[i]]' \
        'self._options_by_id.get(links[i], links[i].lstrip("#opt-"))'
    '';
  };
  passthru.getOptionsPath = path: value:
    if path == [ ] then value
    else getOptionsPath (tail path) (if isOption value then value.type.getSubOptions value.loc else value).${head path};
  passthru.build = { options }: rec {
    manualPath = "${nixpkgsPath}/nixos/doc/manual";
    common = import "${manualPath}/common.nix";
    revision = "none";
    doc = nixosOptionsDoc {
      inherit revision options;
      warningsAreErrors = false;
    };
    optionsJSON = doc.optionsJSON.overrideAttrs {
      preferLocalBuild = true;
      allowSubstitutes = false;
    };
    result = runCommandLocal "options-man"
      {
        passAsFile = [ "script" ];
        script = ''
          #!/bin/sh
          MANPATH=${placeholder "out"} man options
        '';
      }
      ''
        mkdir -p $out/{bin,man5}
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
        cp $scriptPath $out/bin/options-man
        chmod +x $out/bin/options-man
      '';
  }.result;
  passthru = {
    run =
      let
        go = attrs:
          if isDerivation attrs then attrs else
          mapAttrValues go
            ((if isOption attrs then attrs.type.getSubOptions attrs.loc else attrs) // { _run = build { options = attrs; }; });
      in
      go allOptions;
    base = fix (self: {
      nixos = inputs.nixpkgs.lib.nixosSystem {
        modules = [{
          nixpkgs = { inherit pkgs; };
          system.stateVersion = "FAKE";
        }];
      };
      no = self.nixos;
      home-manager = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ options, ... }: {
            home.stateVersion = last options.home.stateVersion.type.functor.payload.values;
            home.username = "FAKE";
            home.homeDirectory = "/FAKE";
          })
        ];
      };
      hm = self.home-manager;
      nix-darwin = inputs.nix-darwin.lib.darwinSystem {
        modules = [{
          nixpkgs = { inherit pkgs; };
        }];
      };
      nd = self.nix-darwin;
    });
    extra = {
      nixvim = inputs.nixvim.lib.evalNixvim {
        modules = [{
          nixpkgs = { inherit pkgs; };
        }];
      };
      tfn = (tfn.build { configPath = ../terraform/config.nix; }).unsanitized;
      devenv = let flake = import devenv.src; in flake.lib.mkEval {
        inherit (flake) inputs;
        inherit pkgs;
        modules = [ ];
      };
    };
    machines = nixosConfigurations // darwinConfigurations;
    allOptions = mapAttrValues (c: c.options) (base // extra // machines);
  };
})
