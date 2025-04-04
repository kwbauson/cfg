scope: with scope;
rustPlatform.buildRustPackage rec {
  pname = "uv";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    rev = version;
    hash = "sha256-CTMEjqV3Cn/Zt91OpNwF3bTLoTD/TPeRsGvLohI15Ng=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-dtbyjVKBipxqeRYddjCfRXx6wgVXzblow2PY4JufKKw=";
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ bash ];
  postPatch = ''
    sed -i '/let attempts = \[".bin.sh"/s@"/bin/sh"@"${bash}/bin/sh"@' crates/uv-python/src/libc.rs
  '';
  doCheck = false;
  meta.mainProgram = "uv";
  meta.skipBuild = true;
}
