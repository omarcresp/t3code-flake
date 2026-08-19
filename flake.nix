{
  description = "T3 Code desktop app flake for Linux and macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      releases = import ./releases.nix;
      repo = "pingdotgg/t3code";

      mkUrl =
        release: asset:
        "https://github.com/${repo}/releases/download/v${release.version}/T3-Code-${release.version}-${asset}";

      assetSuffixes = {
        x86_64-linux = "x86_64.AppImage";
        aarch64-darwin = "arm64.zip";
      };

      mkSource =
        release: system:
        release.sources.${system}
        // {
          url = mkUrl release assetSuffixes.${system};
        };

      supportedSystems = builtins.attrNames releases.stable.sources;

      channels = {
        stable = {
          release = releases.stable;
          pname = "t3-code";
          libexecName = "t3-code";
          desktopFileName = "t3-code";
          desktopName = null;
          iconName = null;
          darwinBundleName = "T3 Code (Alpha)";
          autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];
        };

        nightly = {
          release = releases.nightly;
          pname = "t3-code-nightly";
          libexecName = "t3-code-nightly";
          desktopFileName = "t3-code-nightly";
          desktopName = "T3 Code (Nightly)";
          iconName = "t3-code-nightly";
          darwinBundleName = "T3 Code (Nightly)";
          autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];
        };
      };

      mkMeta = system: channel: {
        description = "T3 Code desktop app packaged from upstream release binaries";
        homepage = "https://github.com/${repo}";
        license = lib.licenses.mit;
        mainProgram = "t3code";
        platforms = [ system ];
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      };

      mkLinuxPackage =
        pkgs: channel:
        let
          system = pkgs.stdenv.hostPlatform.system;
          version = channel.release.version;
          src = pkgs.fetchurl (mkSource channel.release system);
          desktopPath = "$out/share/applications/${channel.desktopFileName}.desktop";
        in
        pkgs.stdenv.mkDerivation {
          inherit (channel) pname;
          inherit version;

          src = pkgs.appimageTools.extract {
            inherit (channel) pname;
            inherit version src;
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

          inherit (channel) autoPatchelfIgnoreMissingDeps;

          dontWrapGApps = true;
          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/libexec/${channel.libexecName}
            cp -R . $out/libexec/${channel.libexecName}
            chmod -R u+w $out/libexec/${channel.libexecName}
            rm -rf $out/libexec/${channel.libexecName}/AppRun \
              $out/libexec/${channel.libexecName}/t3code.desktop \
              $out/libexec/${channel.libexecName}/t3code.png \
              $out/libexec/${channel.libexecName}/.DirIcon \
              $out/libexec/${channel.libexecName}/usr

            install -Dm444 t3code.desktop ${desktopPath}
            mkdir -p $out/share/icons
            cp -R usr/share/icons/hicolor $out/share/icons/hicolor

            substituteInPlace ${desktopPath} \
              --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=t3code %U'

            ${lib.optionalString (channel.desktopName != null) ''
              if grep -q '^Name=' ${desktopPath}; then
                sed -i '0,/^Name=.*/s//Name=${channel.desktopName}/' ${desktopPath}
              fi
            ''}

            ${lib.optionalString (channel.iconName != null) ''
              if grep -q '^Icon=' ${desktopPath}; then
                sed -i 's/^Icon=.*/Icon=${channel.iconName}/' ${desktopPath}
              fi

              find $out/share/icons/hicolor -type f -name 't3code.png' \
                -exec sh -c 'for icon do mv "$icon" "$(dirname "$icon")/${channel.iconName}.png"; done' sh {} +
            ''}

            rm $out/libexec/${channel.libexecName}/libvulkan.so.1
            ln -s ${lib.getLib pkgs.vulkan-loader}/lib/libvulkan.so.1 $out/libexec/${channel.libexecName}/

            runHook postInstall
          '';

          postFixup = ''
            makeWrapper $out/libexec/${channel.libexecName}/t3code $out/bin/t3code \
              "''${gappsWrapperArgs[@]}" \
              --set T3CODE_DISABLE_AUTO_UPDATE 1

            makeWrapper $out/libexec/${channel.libexecName}/t3code $out/bin/t3 \
              --set ELECTRON_RUN_AS_NODE 1 \
              --add-flag $out/libexec/${channel.libexecName}/resources/app.asar/apps/server/dist/bin.mjs
          '';

          meta = mkMeta system channel;
        };

      mkDarwinPackage =
        pkgs: channel:
        let
          system = pkgs.stdenv.hostPlatform.system;
          version = channel.release.version;
          src = pkgs.fetchurl (mkSource channel.release system);
          appName = "${channel.darwinBundleName}.app";
          executable = channel.darwinBundleName;
        in
        pkgs.stdenvNoCC.mkDerivation {
          inherit (channel) pname;
          inherit version src;

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

            # Keep the upstream .app bundle byte-for-byte signed. Mutating
            # Info.plist invalidates the code signature and macOS SIGKILLs it.
            makeWrapper \
              "$out/Applications/${appName}/Contents/MacOS/${executable}" \
              "$out/bin/t3code" \
              --set T3CODE_DISABLE_AUTO_UPDATE 1

            makeWrapper \
              "$out/Applications/${appName}/Contents/MacOS/${executable}" \
              "$out/bin/t3" \
              --set ELECTRON_RUN_AS_NODE 1 \
              --add-flag "$out/Applications/${appName}/Contents/Resources/app.asar/apps/server/dist/bin.mjs"

            runHook postInstall
          '';

          meta = mkMeta system channel;
        };

      mkPackage =
        system: channel:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        if pkgs.stdenv.hostPlatform.isLinux then
          mkLinuxPackage pkgs channel
        else if pkgs.stdenv.hostPlatform.isDarwin then
          mkDarwinPackage pkgs channel
        else
          throw "Unsupported system: ${system}";
    in
    {
      packages = lib.genAttrs supportedSystems (
        system:
        let
          stable = mkPackage system channels.stable;
          nightly = mkPackage system channels.nightly;
        in
        {
          default = stable;
          t3-code = stable;
          t3-code-nightly = nightly;
        }
      );

      apps = lib.genAttrs supportedSystems (
        system:
        let
          mkApp = package: program: description: {
            type = "app";
            program = "${package}/bin/${program}";
            meta = { inherit description; };
          };
          stablePackage = self.packages.${system}.t3-code;
          nightlyPackage = self.packages.${system}.t3-code-nightly;
          stableGui = mkApp stablePackage "t3code" "Run T3 Code";
          stableCli = mkApp stablePackage "t3" "Run the T3 Code headless CLI";
          nightlyGui = mkApp nightlyPackage "t3code" "Run T3 Code Nightly";
          nightlyCli = mkApp nightlyPackage "t3" "Run the T3 Code Nightly headless CLI";
        in
        {
          default = stableGui;
          t3-code = stableGui;
          t3-code-nightly = nightlyGui;
          t3code = stableGui;
          t3code-nightly = nightlyGui;
          t3 = stableCli;
          t3-nightly = nightlyCli;
        }
      );

      checks = lib.genAttrs supportedSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          stable = self.packages.${system}.t3-code;
          nightly = self.packages.${system}.t3-code-nightly;
        in
        {
          t3-cli = pkgs.runCommand "t3-cli-check" { nativeBuildInputs = [ pkgs.coreutils ]; } ''
            for package in ${stable} ${nightly}; do
              help="$(timeout 30 "$package/bin/t3" serve --help 2>&1)"
              grep -F 't3 serve' <<<"$help"
              grep -F 'Run the T3 Code server without opening a browser' <<<"$help"
            done
            touch $out
          '';
        }
      );
    };
}
