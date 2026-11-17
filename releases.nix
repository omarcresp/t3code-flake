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
    version = "0.1.11-nightly.20261117.4814";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-xkfEqzPkMlOcxPoVuVjh9DV4muDBuqgsAVfxqE59bJo=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.11-nightly.20261117.4814-arm64.zip";
        hash = "sha256-EUZ7mA8jvsr5gZthiJFbsFA4V1jJgXYxaa8bummg99M=";
      };
    };
  };
}
