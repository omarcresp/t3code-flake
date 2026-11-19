{
  stable = {
    version = "0.1.10";
    sources = {
      x86_64-linux = {
        file = "T3-Code-x86_64.AppImage";
        hash = "sha256-fN7RPBB1cVOQHt3ayaJgixVvF0Rd5Qbvn/33PAFSjXk=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.10-arm64.zip";
        hash = "sha256-PTTJ73lWSVosgw0ygMIXwpm65HyyuRRBUmB/aBdM8RY=";
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
