{
  description = "Development environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, self, ... } @ inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-darwin" ]
    (system:
      let
        pkgs = import nixpkgs {
            inherit system;
        };
      in {
        devShells.default = with pkgs;
          mkShell {
            buildInputs = [
              prek
              hugo
            ];
            shellHook = ''
              prek install --install-hooks
            '';
          };
    }
  );
}
