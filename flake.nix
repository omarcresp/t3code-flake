{
  description = "T3 Code desktop app flake for Linux and macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      pname = "t3-code";
      version = "0.0.11";

      sources = {
        x86_64-linux = {
          url = "https://github.com/pingdotgg/t3code/releases/download/v0.0.11/T3-Code-0.0.11-x86_64.AppImage";
          hash = "sha256-tasWxWSpPZV++N34FdcmM7sk5c81fBUP1PmsbBpMRHM=";
        };
        x86_64-darwin = {
          url = "https://github.com/pingdotgg/t3code/releases/download/v0.0.11/T3-Code-0.0.11-x64.zip";
          hash = "sha256-ID/by6aZWENh03cUdvTRbjgrvGoSEexqt1TcKOq/ogA=";
        };
        aarch64-darwin = {
          url = "https://github.com/pingdotgg/t3code/releases/download/v0.0.11/T3-Code-0.0.11-arm64.zip";
          hash = "sha256-bZ3t7pEK+R3t5QYY650qSziLnYGQ4i8EnOtRAxpwgJQ=";
        };
      };

      supportedSystems = builtins.attrNames sources;

      mkMeta = system: {
        description = "T3 Code desktop app packaged from upstream release binaries";
        homepage = "https://github.com/pingdotgg/t3code";
        license = lib.licenses.mit;
        mainProgram = "t3-code";
        platforms = [ system ];
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };

      mkLinuxPackage =
        pkgs:
        let
          system = pkgs.stdenv.hostPlatform.system;
          src = pkgs.fetchurl sources.${system};
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

          meta = mkMeta system;
        };

      mkDarwinPackage =
        pkgs:
        let
          system = pkgs.stdenv.hostPlatform.system;
          src = pkgs.fetchurl sources.${system};
          appName = "T3 Code (Alpha).app";
          executable = "T3 Code (Alpha)";
        in
        pkgs.stdenvNoCC.mkDerivation {
          inherit pname version src;

          nativeBuildInputs = [
            pkgs.makeBinaryWrapper
            pkgs.unzip
          ];

          dontFixup = true;

          unpackPhase = ''
            runHook preUnpack
            unzip -q "$src"
            runHook postUnpack
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p "$out/Applications" "$out/bin"
            cp -R "${appName}" "$out/Applications/"

            makeWrapper \
              "$out/Applications/${appName}/Contents/MacOS/${executable}" \
              "$out/bin/t3-code"

            runHook postInstall
          '';

          meta = mkMeta system;
        };

      mkPackage =
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        if pkgs.stdenv.hostPlatform.isLinux then
          mkLinuxPackage pkgs
        else if pkgs.stdenv.hostPlatform.isDarwin then
          mkDarwinPackage pkgs
        else
          throw "Unsupported system: ${system}";
    in
    {
      packages = lib.genAttrs supportedSystems (
        system:
        let
          package = mkPackage system;
        in
        {
          default = package;
          t3-code = package;
        }
      );

      apps = lib.genAttrs supportedSystems (
        system:
        let
          package = self.packages.${system}.t3-code;
        in
        {
          default = self.apps.${system}.t3-code;
          t3-code = {
            type = "app";
            program = "${package}/bin/t3-code";
          };
        }
      );
    };
}
