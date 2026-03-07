# T3 Code AppImage Flake

Standalone flake for consuming the upstream Linux AppImage build of T3 Code.

## Outputs

- `packages.x86_64-linux.default`
- `packages.x86_64-linux.t3-code`
- `apps.x86_64-linux.default`
- `apps.x86_64-linux.t3-code`

## Usage

Run directly:

```bash
nix run .#t3-code
```

Build package:

```bash
nix build .#t3-code
```

Example NixOS usage (from another flake):

```nix
{
  inputs.t3code-appimage.url = "path:./flake";

  outputs = { self, nixpkgs, t3code-appimage, ... }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          environment.systemPackages = [
            t3code-appimage.packages.${pkgs.system}.default
          ];
        })
      ];
    };
  };
}
```
