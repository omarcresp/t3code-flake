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
    version = "0.1.13-nightly.20261126.5305";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-SCAtYpT8au0ef0o2sneHCBIlp/EfShuIW3Om33CCQWQ=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.13-nightly.20261126.5305-arm64.zip";
        hash = "sha256-F+bPrE27cNkk1DXeyttApE6hTrK4jCsxMRpkSA3CF5w=";
      };
    };
  };
}
