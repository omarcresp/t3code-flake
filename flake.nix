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
      version = "0.0.27";

      mkUrl =
        asset: "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-${asset}";

      sources = {
        x86_64-linux = {
          url = mkUrl "x86_64.AppImage";
          hash = "sha256-ALkm7wSVbDlZR7TWVag3NRbP1kvGJQqmpR1mmZvSCAU=";
        };
        aarch64-darwin = {
          url = mkUrl "arm64.zip";
          hash = "sha256-2teOphbCdl1mQHFvDUK+qVdBdwHD/9uu/lY4VmRf1hU=";
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
        in
        pkgs.stdenv.mkDerivation {
          inherit pname version;

          src = pkgs.appimageTools.extract {
            inherit pname version src;
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.makeWrapper
            pkgs.wrapGAppsHook3
          ];

          # Electron runtime dependencies, mirroring
          # nixpkgs pkgs/development/tools/electron/binary/generic.nix
          # (minus pipewire: only used for Wayland screen sharing and it
          # drags gstreamer/ffmpeg/python into the closure, ~200 MiB)
          buildInputs = with pkgs; [
            alsa-lib
            at-spi2-atk
            cairo
            cups
            dbus
            expat
            gdk-pixbuf
            glib
            gtk3
            libGL
            libdrm
            libgbm
            libxkbcommon
            libxshmfence
            nspr
            nss
            pango
            stdenv.cc.cc
            systemdLibs
            vulkan-loader
            libX11
            libXcomposite
            libXdamage
            libXext
            libXfixes
            libXrandr
            libxcb
            libxkbfile
          ];

          # Chromium and bundled ANGLE load these with dlopen, so
          # autoPatchelfHook cannot discover them from DT_NEEDED. Runpaths
          # are not transitive, hence appendRunpaths (all ELF files) instead
          # of runtimeDependencies (executables only).
          appendRunpaths = map (pkg: "${lib.getLib pkg}/lib") (
            with pkgs;
            [
              libGL
              libnotify
              libpulseaudio
              libsecret
              pciutils
              vulkan-loader
            ]
          );

          dontWrapGApps = true;
          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/libexec/t3-code
            cp -R . $out/libexec/t3-code
            chmod -R u+w $out/libexec/t3-code
            rm -rf $out/libexec/t3-code/AppRun \
              $out/libexec/t3-code/t3code.desktop \
              $out/libexec/t3-code/t3code.png \
              $out/libexec/t3-code/.DirIcon \
              $out/libexec/t3-code/usr

            install -Dm444 t3code.desktop $out/share/applications/t3-code.desktop
            mkdir -p $out/share/icons
            cp -R usr/share/icons/hicolor $out/share/icons/hicolor

            substituteInPlace $out/share/applications/t3-code.desktop \
              --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=t3-code %U'

            rm $out/libexec/t3-code/libvulkan.so.1
            ln -s ${lib.getLib pkgs.vulkan-loader}/lib/libvulkan.so.1 $out/libexec/t3-code/

            runHook postInstall
          '';

          postFixup = ''
            makeWrapper $out/libexec/t3-code/t3code $out/bin/t3-code \
              "''${gappsWrapperArgs[@]}" \
              --set T3CODE_DISABLE_AUTO_UPDATE 1
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

            # Note: launching the .app bundle directly (e.g. from Finder)
            # bypasses this wrapper and its environment.
            makeWrapper \
              "$out/Applications/${appName}/Contents/MacOS/${executable}" \
              "$out/bin/t3-code" \
              --set T3CODE_DISABLE_AUTO_UPDATE 1

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
          app = {
            type = "app";
            program = lib.getExe self.packages.${system}.t3-code;
            meta.description = "Run T3 Code";
          };
        in
        {
          default = app;
          t3-code = app;
        }
      );
    };
}
