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
    version = "0.1.14-nightly.20261128.5385";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-tAMcv8P9AIMOWGlsEikE6paRqIvkpn08UKvaI4N+Y1Y=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.14-nightly.20261128.5385-arm64.zip";
        hash = "sha256-H3xU4kXxtqvLkJtmzWlJygo4qQQ32NMrWcy0TgMIpF0=";
      };
    };
  };
}
