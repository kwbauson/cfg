{ path
, pkgs
, package-json ? path + "/package.json"
, package-lock-json ? path + "/package-lock.json"
, nodejs ? pkgs.nodejs_latest
}:
with builtins; with pkgs; with lib;
rec {
  inherit pkgs lib;
  package = importJSON package-json;
  package-lock = {
    name = "node-modules-env";
    version = "1.0.0";
  } // importJSON package-lock-json // {
    bundled = true;
    requires = package.dependencies or { } // package.devDependencies or { };
  };

  inherit (package-lock) name version requires dependencies;

  unpackDep = { resolved, integrity, ... }:
    runCommand
      (removeSuffix ".tgz" (baseNameOf resolved))
      { } ''
      mkdir unpack
      cd unpack
      unpackFile ${fetchurl { url = resolved; hash = integrity; }}
      mv * $out
    '';

  buildDep = entry: pdeps: with rec {
    deps = pdeps // buildDeps entry.dependencies or { } deps;
    link-cmd = "ln -s ${buildReqs entry.requires deps} $out/node_modules";
  };
    runCommand
      (baseNameOf entry.resolved)
      { buildInputs = [ libarchive ]; } ''
      mkdir unpack && cd unpack
      bsdtar xf ${fetchurl { url = entry.resolved; hash = entry.integrity; }}
      find . -type d -exec chmod +x {} \;
      mv * $out
      ${optionalString (entry ? requires) link-cmd}
    '';

  buildDeps = entries: pdeps: rec {
    deps = pdeps // built;
    fn = e: if e.bundled or false then null else buildDep e deps;
    built = mapAttrs (_: fn) entries;
  }.built;

  buildReqs = requires: deps: with {
    included = filter (n: deps.${n} != null) (attrNames requires);
    link = n: ''
      dir=$(dirname ${n})
      [[ -d $dir ]] || mkdir $dir
      ln -s ${deps.${n}} ${n}
    '';
  };
    runCommand "node_modules"
      { } ''
      mkdir -p $out
      cd $out
      ${concatStrings (map link included)}
    '';

  deps = buildDeps dependencies { };
  out = with {
    scopes = unique (map (n: head (splitString "/" n)) (filter (hasInfix "/") (attrNames deps)));
    entries = mapAttrsToList (dst: src: { inherit dst src; }) deps;
    link = { src, dst }: "ln -s ${src} ${dst}";
  };
    runCommand "${name}-node_modules"
      { } ''
      mkdir $out && cd $out
      ${optionalString (length scopes > 0) "mkdir ${concatStringsSep " " scopes}"}
      ${concatMapStringsSep "\n" link entries}
    '';

  wrapped-nodejs =
    runCommand "wrapped-nodejs"
      { buildInputs = [ makeWrapper ]; } ''
      mkdir -p $out/bin
      ln -s ${nodejs}/bin/* $out/bin
      for exe in $out/bin/*;do
        wrapProgram $exe --set NODE_PRESERVE_SYMLINKS 1 --set NODE_PATH ${out}
      done
    '';

  binEntry = path: with rec {
    json = importJSON "${path}/package.json";
    bin = json.bin or { };
    entries = if isString bin then { ${json.name} = bin; } else bin;
  }; mapAttrsToList (name: bin: { inherit name; path = "${path}/${bin}"; }) entries;

  bin = with rec {
    entries = flatten (map binEntry (map (n: deps.${n}) (attrNames requires)));
    writeEntry = { name, path }: ''
      echo '#!/bin/sh' > ${name}
      echo 'exec ${wrapped-nodejs}/bin/node ${path} "$@"' >> ${name}
      chmod +x ${name}
    '';
  };
    runCommand "${name}-bin"
      { } ''
      mkdir -p $out/bin
      cd $out/bin
      ${concatMapStrings writeEntry entries}
    '';

  env = (
    buildEnv {
      name = "node-env";
      paths = [ wrapped-nodejs bin ];
    }
  ) // { node_modules = out; };
}.env
