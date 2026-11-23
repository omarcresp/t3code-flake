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
    version = "0.1.12-nightly.20261123.5151";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-ApvrN8dgBvjmYAOiUBt6bLFNx+RGMBL2eUmWGhpxDgk=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.12-nightly.20261123.5151-arm64.zip";
        hash = "sha256-pLBnIeaWPvgpGF3xE557AdPg0tzXD3wXvmNxhapXcRw=";
      };
    };
  };
}
