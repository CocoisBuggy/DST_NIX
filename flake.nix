{
  description = "Don't Starve Together nixos flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        foreground = import ./tools/foreground.nix { inherit pkgs; };
      in
      {
        packages.default = foreground;

        apps.default = {
          type = "app";
          program = "${foreground}";
        };
      }
    )
    // {
      nixosModules.default = import ./modules/service.nix;
    };
}
