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
    version = "0.1.10-nightly.20261116.4800";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-y4AHEIxauXKxR+euYjMCexIUNpVQBoZeOCPk+ee5B8w=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.10-nightly.20261116.4800-arm64.zip";
        hash = "sha256-UI43HFMgUg00iM/RiOQDPnhZqS/g38TGVDwyQZJYCJw=";
      };
    };
  };
}
