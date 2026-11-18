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
    version = "0.1.11-nightly.20261118.4877";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-8k+NBzoTofAaXnxWCDJLGJRPKzRoGvH7d6/y6rvk3BQ=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.11-nightly.20261118.4877-arm64.zip";
        hash = "sha256-N4eyPFa4pbYCho30HaYS+hwwbMtOg3Av4ad5wkMFz5E=";
      };
    };
  };
}
