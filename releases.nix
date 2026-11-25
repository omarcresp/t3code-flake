{
  stable = {
    version = "0.1.12";
    sources = {
      x86_64-linux = {
        file = "T3-Code-x86_64.AppImage";
        hash = "sha256-ZrkVUVcd9tKbVctZApXt9BHP+WyVqP6z9Bw8pZXXIuI=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.12-arm64.zip";
        hash = "sha256-bMxS4Q2dQGeTjbfNU11Q2Bk4ZP6/oc+myEhbw6p9v7c=";
      };
    };
  };

  nightly = {
    version = "0.1.13-nightly.20261125.5258";
    sources = {
      x86_64-linux = {
        file = "T3-Code-Nightly-x86_64.AppImage";
        hash = "sha256-ScVxQGUbI29gHovDNYqmXPjbRE9nCzjhnm/KNuCnvKA=";
      };
      aarch64-darwin = {
        file = "T3-Code-0.1.13-nightly.20261125.5258-arm64.zip";
        hash = "sha256-qjguuDAFAnDoNncbnYaQgncDOE/ly9tNH6AePyDzQGM=";
      };
    };
  };
}
