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
    version = "0.1.12-nightly.20261121.5024";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-UjOU+juT8Og3Z4Ugiu+EX4O7td8IkIYln+CPz8G7cX4=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.12-nightly.20261121.5024-arm64.zip";
        hash = "sha256-JCt0rfpAuRIV2cpSXug7tASl3s0/IEzx5CcQmsGiZ/4=";
      };
    };
  };
}
