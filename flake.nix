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
        entrypoint = pkgs.writeShellScriptBin "myapp" (builtins.readFile ./entrypoint.sh);
        foreground = import ./tools/foreground.nix { inherit pkgs; };
      in
      {
        packages.default = entrypoint;
        packages.foreground = foreground;

        apps.default = {
          type = "app";
          program = "${entrypoint}/bin/dst";
        };

        apps.dst-server-foreground = {
          type = "app";
          program = "${foreground}/bin/dst-server-foreground";
        };
      }
    )
    // {
      nixosModules.default = import ./modules/service.nix;
    };
}
