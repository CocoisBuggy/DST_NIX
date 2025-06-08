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
        instanceName = mkOption {
          type = types.str;
          default = name; # Use the attribute name as the instance name by default
          description = "Name of the DST server instance (e.g., 'matthew_torment').";
        };

        cluster_token = mkOption {
          type = types.str;
          description = "Klei cluster token for this instance.";
        };

        # --- Options for the Master Shard ---
        master = {
          # These are options for the Master shard's specific settings
          # (e.g., from your previous snippet: bind_ip, master_ip, etc.)
          bind_ip = mkOption {
            type = types.str;
            default = "127.0.0.1";
          };
          server_port = mkOption {
            type = types.int;
            default = 10999;
            description = "Main server port for Master.";
          };
          cluster_key = mkOption {
            type = types.str;
            default = "supersecretkey";
          }; # Key for inter-shard comms

          # Options for GAMEPLAY settings (these are the ones missing in your INI)
          gameplay = {
            maxPlayers = mkOption {
              type = types.int;
              default = 6;
            };
            pvpEnabled = mkOption {
              type = types.bool;
              default = false;
            };
            gameMode = mkOption {
              type = types.str;
              default = "survival";
            };
            # ... more gameplay options
          };

          # This will be the *generated INI content object* for the Master shard
          ini = mkOption {
            type = types.attrs; # It's an attrset, but its value is derived
            readOnly = true; # Mark as read-only because it's computed
            description = "The generated INI content for the Master shard's server.ini.";
          };

          # Similarly for Lua worldgenoverride
          lua = mkOption {
            type = types.attrs; # Use types.attrs or types.submodule if it has a structure
            readOnly = true;
            description = "The Lua config for Master shard's worldgenoverride.lua.";
          };
        };

        # --- Options for the Caves Shard ---
        caves = {
          # These are options for the Caves shard's specific settings
          bind_ip = mkOption {
            type = types.str;
            default = "127.0.0.1";
          };
          server_port = mkOption {
            type = types.int;
            default = 10998;
            description = "Main server port for Caves.";
          };
          master_ip = mkOption {
            type = types.str;
            default = "127.0.0.1";
          }; # Caves connects to Master
          master_port = mkOption {
            type = types.int;
            default = 10889;
          }; # Caves connects to Master
          cluster_key = mkOption {
            type = types.str;
            default = "supersecretkey";
          }; # Needs to match master

          ini = mkOption {
            type = types.attrs;
            readOnly = true;
            description = "The generated INI content for the Caves shard's server.ini.";
          };

          lua = mkOption {
            type = types.attrs;
            readOnly = true;
            description = "The Lua config for Caves shard's worldgenoverride.lua.";
          };
        };
      };

      # --- Configuration for a single instance (where the magic happens) ---
      config = {
        # Master shard's INI object (this is the key refactor)
        # We combine the gameplay options (from the instance's master.gameplay)
        # with network options, etc., into the structure expected by lib.generators.toINI
        master.ini = {
          GAMEPLAY = {
            max_players = config.master.gameplay.maxPlayers;
            pvp = if config.master.gameplay.pvpEnabled then "true" else "false";
            game_mode = config.master.gameplay.gameMode;
            # ... other gameplay attrs
          };
          NETWORK = {
            server_port = toString config.master.server_port;
            server_ip = config.master.bind_ip;
            # ... other network attrs
          };
          # [SHARD] section for Master shard.ini
          SHARD = {
            shard_name = "Master";
            shard_id = "Master";
            is_master = true;
            cluster_key = config.master.cluster_key;
          };
          # ... other sections like [STEAM], [MISC]
        };

        # Caves shard's INI object
        caves.ini = {
          GAMEPLAY = {
            # Caves usually inherits some gameplay settings from Master
            # or you can define them independently in caves.gameplay options
            max_players = config.master.gameplay.maxPlayers; # Example: using Master's max players
            pvp = if config.master.gameplay.pvpEnabled then "true" else "false";
            game_mode = config.master.gameplay.gameMode;
            # ... more gameplay attrs specific to caves if needed
          };
          NETWORK = {
            server_port = toString config.caves.server_port;
            server_ip = config.caves.bind_ip;
            # ... other network attrs
          };
          # [SHARD] section for Caves shard.ini
          SHARD = {
            shard_name = "Caves";
            shard_id = "Caves";
            is_master = false; # Caves is not the master shard
            master_ip = config.caves.master_ip;
            master_port = toString config.caves.master_port;
            cluster_key = config.caves.cluster_key; # Must match master_key
          };
          # ... other sections
        };

        # Master shard's Lua override (example structure)
        master.lua = {
          # Lua objects usually have a specific structure required by renderLuaFile
          # Example: for worldgenoverride.lua, it's often a table with PREFAB, PRESET, etc.
          PREFAB = "world";
          PRESET = "DEFAULT"; # Or 'MEDIUM', 'SMALL', etc.
          # ... more worldgenoverride settings
        };

        # Caves shard's Lua override
        caves.lua = {
          # Same structure as master.lua but for caves
          PREFAB = "cave";
          PRESET = "DEFAULT_CAVE";
          # ...
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
