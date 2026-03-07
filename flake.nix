{
  description = "T3 Code AppImage flake for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      t3Code =
        let
          pname = "t3-code";
          version = "0.0.3";

          src = pkgs.fetchurl {
            url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
            hash = "sha256-1fKkfIFCLTutZBhPumqvo00PjmZO630wLnB9N5Ge5ZY=";
          };

          appimageContents = pkgs.appimageTools.extractType2 {
            inherit pname version src;
          };
        in
        pkgs.appimageTools.wrapType2 {
          inherit pname version src;

          extraPkgs = _pkgs: [ ];

          extraInstallCommands = ''
            install -Dm444 ${appimageContents}/t3-code-desktop.desktop \
              $out/share/applications/t3-code.desktop
            install -Dm444 ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/t3-code-desktop.png \
              $out/share/pixmaps/t3-code.png
            install -Dm444 ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/t3-code-desktop.png \
              $out/share/icons/hicolor/1024x1024/apps/t3-code.png

            substituteInPlace $out/share/applications/t3-code.desktop \
              --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=t3-code %U' \
              --replace-fail 'Icon=t3-code-desktop' "Icon=$out/share/pixmaps/t3-code.png"
          '';

          meta = {
            description = "T3 Code desktop app packaged from the upstream AppImage";
            homepage = "https://github.com/pingdotgg/t3code";
            license = pkgs.lib.licenses.mit;
            platforms = [ "x86_64-linux" ];
            mainProgram = "t3-code";
          };
        };
    in
    {
      packages.${system} = {
        default = t3Code;
        t3-code = t3Code;
      };

      apps.${system} = {
        default = self.apps.${system}.t3-code;
        t3-code = {
          type = "app";
          program = "${t3Code}/bin/t3-code";
        };
      };
    };
}
