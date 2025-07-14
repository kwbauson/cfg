scope: with scope;
args: (stdenv.mkDerivation (attrs:
  let
    name = args.pname or args.name; # FIXME this isn't overridable anymore
  in
  {
    dontUnpack = true;
    passAsFile = [ "script" ];
    nativeBuildInputs = [ argc installShellFiles gnused makeWrapper ];
    buildPhase = ''
      runHook preBuild

      mkdir src
      src=src/${name}
      cp $scriptPath $src
      sed -i 1i'#!/usr/bin/env bash' $src

      argc --argc-build $src ${name}
      argc --argc-mangen $src man

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      installBin ${name}
      wrapProgram $out/bin/${name} \
        --prefix PATH : ${lib.makeBinPath attrs.buildInputs or []}
      installManPage man/*
      installShellCompletion --cmd ${name} \
        --bash <(argc --argc-completions bash) \
        --fish <(argc --argc-completions fish) \
        --zsh <(argc --argc-completions zsh)

      runHook postInstall
    '';
    meta.mainProgram = name;
  })).overrideAttrs ({ __intentionallyOverridingVersion = true; } // args)
