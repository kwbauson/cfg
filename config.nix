{
  allowUnfree = true;
  pulseaudio = true;
  allowBroken = true;
  # allowUnsupportedSystem = true;
  android_sdk.accept_license = true;
  chromium = {
    enableWideVine = true;
    # enablePepperFlash = true;
  };
  # contentAddressedByDefault = true;
  zathura.useMupdf = false;
  permittedInsecurePackages = [
    "nodejs-16.20.0"
    "ruby-2.7.8"
    "openssl-1.1.1u"
  ];
}
