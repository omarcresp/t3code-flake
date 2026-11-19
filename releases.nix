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
    version = "0.1.11-nightly.20261118.4903";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-oWBIgla0Z+vrtpVngmIlvH11qjN5gagL2w2qRacoawY=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.11-nightly.20261118.4903-arm64.zip";
        hash = "sha256-uMEomo6ALBN9BhCS9h5XMbYMiho5LKdJkprLJAMuvn8=";
      };
    };
  };
}
