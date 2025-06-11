![The man who inspired this, Matthew](./static/image.png)

# Don't Starve Dedicated Server

There is a lovely repo that already exists to [help demonstrate config and provide docker containers for running servers](https://github.com/mathielo/dst-dedicated-server/tree/main), but if you are looking for a nix-friendly way here is my best guess at how that should go.

## Quickstart

```nix
{
  description = "Minimal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dst.url = "github:CocoisBuggy/DST_NIX";
  };

  outputs = { self, nixpkgs, hello-flake, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/default.nix

        # You can also pull in modules from other flakes like this:
        hello-flake.nixosModules.default
      ];
    };
  };
}
```

## Challenges in Development

The server architechture is **not** straightforward, especially if you are used to normal gameserver deployment. Some of the things to respect include

1. The server binary must be run with the working directory in the `..../bin` or `..../bin64` directory. It will not run otherwise
1. The server binary will need access to curl libs with gnu tls enabled - NOT the newer version, rather you need the version from a few years back.
1. Port assignment is a little chaotic given that there are so many port bindings to be made.
