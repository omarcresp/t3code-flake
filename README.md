# t3code-flake

[![Nix Flake](https://img.shields.io/badge/Nix-flake-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![Platform](https://img.shields.io/badge/platform-x86__64--linux-6b7280)](https://github.com/omarcresp/t3code-flake)

A small, focused Nix flake that packages the upstream Linux AppImage for [T3 Code](https://github.com/pingdotgg/t3code).

This repo exposes both a package and an app so you can `nix run`, `nix build`, or consume it from another flake.

## Why This Flake

- Reproducible packaging for the official T3 Code AppImage.
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
      system = "x86_64-linux";
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
| `packages.x86_64-linux.default` | Alias of `t3-code` package |
| `packages.x86_64-linux.t3-code` | Wrapped AppImage package |
| `apps.x86_64-linux.default` | Alias of `t3-code` app |
| `apps.x86_64-linux.t3-code` | Runnable app (`nix run`) |

Inspect outputs:

```bash
nix flake show github:omarcresp/t3code-flake
```

## Platform Support

- `x86_64-linux` only (matches the packaged AppImage asset).

## Troubleshooting

If your Nix install does not have flakes enabled yet, add:

```ini
experimental-features = nix-command flakes
```

to your `nix.conf`.
