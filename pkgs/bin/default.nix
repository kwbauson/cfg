scope: with scope;
pipeValue [
  (removeAttrs (readDir ./.) [ "default.nix" ])
  (mapAttrs (n: _: readFile ./${n}))
  (filterAttrs (_: t: isLinux || !hasInfix "ONLY_LINUX" t))
  (mapAttrs (name: text: (writeScriptBin name text).overrideAttrs (old: {
    nativeBuildInputs = [ makeWrapper ];
    PATH_ADD = pipeValue [
      (splitString "\n" text)
      (filter (hasInfix " with-packages "))
      (map (s: elemAt (splitString " with-packages " s) 1))
      (concatMap (splitString " "))
      (map (n: getAttrFromPath (splitString "." n) pkgs))
      makeBinPath
    ];
    buildCommand = /* bash */ ''
      ${old.buildCommand}
      if [[ -n $PATH_ADD ]];then
        wrapProgram $out/bin/${name} --prefix PATH : "$PATH_ADD"
      fi
    '';
  })))
]
