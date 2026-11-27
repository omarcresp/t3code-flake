{
  stable = {
    version = "0.1.13";
    sources = {
      x86_64-linux = {
        file = "T3-Code-x86_64.AppImage";
        hash = "sha256-2sG76ek8Gl+wlCMyvvqZhZf2oIYjKod2bvXYI1pE9W0=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.13-arm64.zip";
        hash = "sha256-f0b9KwfJDm/ttiP0clvEAwym6GzoL2mkha1JKMqJNQ0=";
      };
    };
  };

  nightly = {
    version = "0.1.14-nightly.20261127.5345";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-tjl0tqY1u4ZNPj1BPQ4R7Jmq9mv6N0BXfkdO4tKIzcI=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.14-nightly.20261127.5345-arm64.zip";
        hash = "sha256-x7GpHngGwLUTl2+rO2XjwHdUWAB6x+Y98oam5pnVtSw=";
      };
    };
  };
}
