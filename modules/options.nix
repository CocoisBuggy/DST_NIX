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

  shardOptions = preset: {
    ini = {
      NETWORK = {
        server_port = mkOption {
          type = types.int;
          example = 11000;
          description = "Each shard has its own port binding";
        };
      };
      SHARD = {
        is_master = mkOption {
          type = types.bool;
          default = (preset == "SURVIVAL_TOGETHER");
          description = "Which shard should the cluster treat as the primary one?";
        };
      };
      STEAM = {
        master_server_port = mkOption {
          type = types.int;
          example = 27018;
          description = "Slightly mystical to me, except that each shard increments by 1";
        };
        authentication_port = mkOption {
          type = types.int;
          example = 8768;
          description = "Slightly mystical to me, except that each shard increments by 1";
        };
      };
    };
    lua = {
      override_enabled = mkOption {
        type = types.bool;
        default = true;
      };
      preset = mkOption {
        type = types.str;
        default = preset;
        description = "SURVIVAL_TOGETHER, DST_CAVE";
      };
      overrides = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "A set of override options.";
      };
    };
  };
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
      type = types.listOf (
        types.submodule (
          { ... }:
          {
            options = {
              cluster_token = mkOption {
                type = types.str;
                description = "A required secret token that the cluster uses to talk to the klei server";
              };

              mods = mkOption {
                type = types.attrsOf (types.submodule modOption);
                default = { };
                description = ''
                  An attribute set of extra mods/entries to configure.
                  Each key represents the workshop ID of the mod/entry,
                  and its value is an attribute set with 'enabled' and 'configuration_options'.
                '';
                example = literalExpression ''
                  mods = {
                    # Global Positions
                    "workshop-2902364746" = {
                      enabled = true;
                      configuration_options = {
                        mode = "Eassy Cartography";
                        someOtherSetting = 123;
                      };
                    };
                    "my-custom-mod" = {
                      enabled = false;
                    };
                  };
                '';
              };

              cluster = {
                GAMEPLAY = {
                  game_mode = mkOption {
                    type = types.str;
                    default = "survival";
                    description = "Game mode for the server (e.g., survival).";
                  };
                  max_players = mkOption {
                    type = types.int;
                    default = 12;
                    description = "Maximum number of players.";
                  };
                  pvp = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Whether PVP is enabled.";
                  };
                  pause_when_empty = mkOption {
                    type = types.bool;
                    default = true;
                    description = "Whether the server pauses when no players are present.";
                  };
                };

                NETWORK = {
                  cluster_description = mkOption {
                    type = types.str;
                    default = "We be starving out here";
                    description = "Cluster description shown to players.";
                  };
                  cluster_name = mkOption {
                    type = types.str;
                    description = "Name of the server cluster.";
                  };
                  cluster_password = mkOption {
                    type = types.str;
                    default = "yippee";
                    description = "Password for the server cluster.";
                  };
                  offline_cluster = mkOption {
                    type = types.bool;
                    default = false;
                  };
                  lan_only_cluster = mkOption {
                    type = types.bool;
                    default = false;
                  };
                };

                MISC = {
                  console_enabled = mkOption {
                    type = types.bool;
                    default = true;
                    description = "Enable the in-game console.";
                  };
                };

                SHARD = {
                  shard_enabled = mkOption {
                    type = types.bool;
                    default = true;
                    description = "Enable shard networking.";
                  };
                  bind_ip = mkOption {
                    type = types.str;
                    default = "127.0.0.1";
                    description = "IP address to bind for this shard.";
                  };
                  master_ip = mkOption {
                    type = types.str;
                    default = "127.0.0.1";
                    description = "IP address of the master shard.";
                  };
                  master_port = mkOption {
                    type = types.int;
                    default = 10889;
                    description = "Port of the master shard.";
                  };
                  cluster_key = mkOption {
                    type = types.str;
                    default = "supersecretkey";
                    description = "Key used for shard authentication.";
                  };
                };
              };

              master = shardOptions "SURVIVAL_TOGETHER";
              caves = shardOptions "DST_CAVE";
            };
          }
        )
      );

      default = [ ];
      description = "List of DST service instances.";
    };
  };
}
