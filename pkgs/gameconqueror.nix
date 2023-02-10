scope: with scope;
scanmem.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [ makeWrapper ];
  buildInputs = old.buildInputs ++ [
    gtk3
    gobject-introspection
    python3.pkgs.pygobject3
  ];
  configureFlags = [ "--enable-gui" ];
  postInstall = ''
    cat > $out/bin/gameconqueror <<EOF
    #!${runtimeShell}
    cd $out/share/gameconqueror
    exec ${python3}/bin/python GameConqueror.py "\$@"
    EOF
    chmod +x $out/bin/gameconqueror
    wrapProgram $out/bin/gameconqueror \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
      --prefix XDG_DATA_DIRS : "$XDG_DATA_DIRS"
  '';
})
