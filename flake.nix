{
  description = "Hugo flake";
  nixConfig.bash-prompt = "\[nix-develop\]$ ";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    utils = {
      url = github:numtide/flake-utils;
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    utils,
    self,
    pre-commit-hooks,
    ...
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true;
              markdownlint.enable = true;
              prettier.enable = true;
            };
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [hugo];
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}
