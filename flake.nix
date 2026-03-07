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

      t3Code = pkgs.appimageTools.wrapType2 rec {
        pname = "t3-code";
        version = "0.0.3";

        src = pkgs.fetchurl {
          url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
          hash = "sha256-1fKkfIFCLTutZBhPumqvo00PjmZO630wLnB9N5Ge5ZY=";
        };

        extraPkgs = _pkgs: [ ];

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
