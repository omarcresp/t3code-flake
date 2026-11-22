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
    version = "0.1.12-nightly.20261122.5085";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-oyx+Py5nru7oQjEvy+r13SvEWxh71Oq9ssFoxvUAM0A=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.12-nightly.20261122.5085-arm64.zip";
        hash = "sha256-V/XN9JPcTlfN0kPzXb1HPeDvqFMZwh4TuVjtkg2/vSU=";
      };
    };
  };
}
