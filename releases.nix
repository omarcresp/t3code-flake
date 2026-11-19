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
    version = "0.1.11-nightly.20261119.4928";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-gSbr2GiLGz9lf8Mjt1TlSskY26M6N1WsKuMy/lVzwmM=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.11-nightly.20261119.4928-arm64.zip";
        hash = "sha256-SDb1KgrvFGqYDlaveXYhn6uyFYpzIuKBZuu/dEu+JWs=";
      };
    };
  };
}
