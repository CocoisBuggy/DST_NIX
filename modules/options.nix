{ lib, ... }:

with lib;

let
  shardOptions = preset: {
    ini = {
      NETWORK = {
        server_port = mkOption {
          type = types.int;
          default = 11000;
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
          default = 27018;
          description = "Slightly mystical to me, except that each shard increments by 1";
        };
        authentication_port = mkOption {
          type = types.int;
          default = 8768;
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
  options.services.dstserver.instances = mkOption {
    type = types.listOf (
      types.submodule (
        { name, ... }:
        {
          options = {
            name = mkOption {
              type = types.str;
              default = name;
              description = "Name of the DST server instance.";
            };

            cluster_token = mkOption {
              type = types.str;
              description = "A required secret token that the cluster uses to talk to the klei server";
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
}
