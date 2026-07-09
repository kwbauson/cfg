{ _overlay, scope }: with scope;
prev.overrideAttrs (old: {
  src = old.src.overrideAttrs (oldSrc: {
    patches = oldSrc.patches or [ ] ++ [ ./hash-based-profile.patch ];
  });
})
