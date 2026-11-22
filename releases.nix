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
    version = "0.1.12-nightly.20261122.5098";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-OnM/O+8y3KxaMx0zzMKa0eWn2ISNTdT2MBHXnMClUkw=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.12-nightly.20261122.5098-arm64.zip";
        hash = "sha256-pNQljJAn4JOHj9Fx9SU85YRl+oUo2G6Gj1qu2DM2Zek=";
      };
    };
  };
}
