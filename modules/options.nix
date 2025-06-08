{ lib, config, ... }:

with lib;

let
  cfg = config.services.dstserver;

  # Define the structure for a single mod or entry
  modOption =
    { name, ... }:
    {
      options = {
        enabled = mkOption {
          type = types.bool;
          default = false;
          description = "Whether this mod/entry is enabled.";
        };

        # Use types.attrsOf types.unspecified or types.anything for flexible configuration_options
        configuration_options = mkOption {
          type = types.attrsOf types.unspecified; # Or types.attrs if you expect attributes
          # type = types.anything; # Even more flexible, allows any Nix value
          default = { };
          description = ''
            Arbitrary configuration options for this mod/entry.
            This will be passed directly to the 'configuration_options' key.
          '';
        };
      };
    };

  # This is the definition for a single DST server instance
  dstInstanceType = types.submodule (
    { config, name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name; # Use the attribute name as the instance name by default
          description = "Name of the DST server instance (e.g., 'matthew_torment').";
        };

        maxPlayers = mkOption {
          type = types.int;
          default = 6;
          description = "max 64, the number of players that may be in this server at once";
        };

        description = mkOption {
          type = types.str;
          description = "Will appear as the server's description";
          default = "";
        };

        password = mkOption {
          type = types.str;
          description = "Does this cluster have a password?";
          default = "";
        };

        cluster_token = mkOption {
          type = types.str;
          description = "Klei cluster token for this instance.";
        };

        pvp = mkOption {
          type = types.bool;
          default = false;
        };

        pauseWhenEmpty = mkOption {
          type = types.bool;
          default = true;
        };

        gameMode = mkOption {
          type = types.str;
          default = "survival";
        };

        overrides.caves = mkOption {
          type = types.attrsOf types.anything;
          default = { };
          description = "These worldgen overrides will be passed to the worldgenlua file";
        };

        overrides.master = mkOption {
          type = types.attrsOf types.anything;
          default = { };
          description = "These worldgen overrides will be passed to the worldgenlua file";
        };
      };
    }
  );
in
{
  options.services.dstserver = {
    userName = mkOption {
      type = types.str;
      default = "dstserver";
      description = "User to run the Don't Starve Together server and steamcmd.";
    };
    groupName = mkOption {
      type = types.str;
      default = "dstserver";
      description = "Group for the Don't Starve Together server user.";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/dstserver";
      description = "Directory to store Don't Starve Together server data and user files.";
    };
    installDir = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/DST_Server";
      description = "Absolute path for Don't Starve Together server installation via steamcmd.";
    };
    instances = mkOption {
      type = types.listOf dstInstanceType;
      default = [ ];
      description = "List of DST service instances.";
    };
  };
}
