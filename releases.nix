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
    version = "0.1.11-nightly.20261117.4838";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-n2ycCnVKyQ8uyUJvgLWvwxhKHGBQiJYsrhMkXpGySUA=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.11-nightly.20261117.4838-arm64.zip";
        hash = "sha256-nCzno7gUFLU3QITXuq83/wUAjo0A6eHlxcKsbmXJiHY=";
      };
    };
  };
}
