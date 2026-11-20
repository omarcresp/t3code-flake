{
  stable = {
    version = "0.1.11";
    sources = {
      x86_64-linux = {
        file = "T3-Code-x86_64.AppImage";
        hash = "sha256-i6oGp7uqP3KdaUZvshHtcAbWpuTYALns2s2DH9FoaxQ=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.11-arm64.zip";
        hash = "sha256-LpJFQDHb/6xF+dxeQ0ge09KdiR+un9WAzu6vKO/l8jA=";
      };
    };
  };

  nightly = {
    version = "0.1.11-nightly.20261119.4954";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-PtdlG0icmAknh/WGWeW22nK+zZ1+6l0pCDglq8XpR8k=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.11-nightly.20261119.4954-arm64.zip";
        hash = "sha256-mx+BH88TpB5EsBZ+lExD9Akk3l4HbkuBKtUC4vWeEMI=";
      };
    };
  };
}
