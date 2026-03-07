# t3code-flake

[![Nix Flake](https://img.shields.io/badge/Nix-flake-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS-6b7280)](https://github.com/omarcresp/t3code-flake)

A small, focused Nix flake that packages the upstream release binaries for [T3 Code](https://github.com/pingdotgg/t3code) on Linux and macOS.

This repo exposes both a package and an app so you can `nix run`, `nix build`, or consume it from another flake.

## Why This Flake

- Reproducible packaging for the official T3 Code release artifacts.
- Clean flake outputs for both package and runnable app workflows.

## Quick Start

Run straight from GitHub:

```bash
nix run github:omarcresp/t3code-flake#t3-code
```

Build locally from a clone:

```bash
nix build .#t3-code
```

Install into your profile:

```bash
nix profile install github:omarcresp/t3code-flake#t3-code
```

## Install as a Flake Input

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    t3code-flake.url = "github:omarcresp/t3code-flake";
  };

  outputs = { self, nixpkgs, t3code-flake, ... }:
    let
      system = builtins.currentSystem;
    in
    {
      # NixOS example
      nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ ... }: {
            environment.systemPackages = [
              t3code-flake.packages.${system}.t3-code
            ];
          })
        ];
      };

      # Home Manager / devShell / plain package set example
      packages.${system}.default = t3code-flake.packages.${system}.t3-code;
    };
}
```

## Flake Outputs

| Output | Description |
| --- | --- |
| `packages.x86_64-linux.default` | Alias of Linux `t3-code` package |
| `packages.x86_64-linux.t3-code` | Wrapped AppImage package |
| `packages.x86_64-darwin.t3-code` | macOS Intel app bundle package |
| `packages.aarch64-darwin.t3-code` | macOS Apple Silicon app bundle package |
| `apps.<system>.t3-code` | Runnable app (`nix run`) for each supported system |

Inspect outputs:

```bash
nix flake show github:omarcresp/t3code-flake
```

## Platform Support

- `x86_64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

## Troubleshooting

If your Nix install does not have flakes enabled yet, add:

```ini
experimental-features = nix-command flakes
```

to your `nix.conf`.
