scope: with scope;
let
  lock = fromJSON (readFile "${cobi.src}/flake.lock");
  locked = lock.nodes.${lock.nodes.root.inputs.pog}.locked;
  src = fetchTarball {
    url = "https://github.com/${locked.owner}/${locked.repo}/archive/${locked.rev}.tar.gz";
    sha256 = locked.narHash;
  };
in
(import "${src}/pog" { inherit pkgs system; }).pog
