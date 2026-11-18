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
    version = "0.1.11-nightly.20261118.4864";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-AZ3vzZ4SaJyQafHVTJDVzYZkor7Np8BKUamQIv/YkKQ=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.11-nightly.20261118.4864-arm64.zip";
        hash = "sha256-Q4NI0Jb33/gQZBCfQcZlXnqeO1J5MjJ1YFGjrgB0gTE=";
      };
    };
  };
}
