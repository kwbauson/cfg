scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-09-16";
  src = fetchFromGitHub {
    owner = "miroslavpejic85";
    repo = pname;
    rev = "ca7efb1c9e52761b9f886eb8210b498b2098abc2";
    hash = "sha256-oeXGFDZcbZ463iFDg6LQl2CF5jMZomkXXUWIEW0NNgI=";
  };
  installPhase = ''
    cp -r . $out
    mkdir -p $out/bin
    cat > $out/bin/${pname} <<-EOF
    #!${stdenv.shell}
    rundir=/tmp/${pname}-run
    mkdir -p "\$rundir"
    trap 'rm -rf "\$rundir"' EXIT
    cd "\$rundir"
    cp -r --no-preserve=mode --target . -- $out/*
    ${bun}/bin/bun install
    ${bun}/bin/bun --bun run start
    EOF
    chmod +x $out/bin/${pname}
  '';
  meta.mainProgram = pname;
  passthru.updateScript = unstableGitUpdater { };
}
