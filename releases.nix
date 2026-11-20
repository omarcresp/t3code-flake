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
    version = "0.1.12-nightly.20261120.4994";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-PwdpSdzOsZhNsbGbNqwIAiaSkFjf6pNAM80Rn6DMYsc=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.12-nightly.20261120.4994-arm64.zip";
        hash = "sha256-Ve7S/A0hHXgU8jrojPhG6eD+KEvkkV/KeSjTm2DJoog=";
      };
    };
  };
}
