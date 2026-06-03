scope: with scope;
addMetaAttrs { includePackage = true; } (writeBashBin pname ''
  ${getExe agenix} --help
'')
