{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.dstserver;

  inherit (pkgs) writeShellScript;
  inherit (lib)
    mkOption
    mkIf
    types
    mapAttrs'
    nameValuePair
    ;

  makeInstanceService =
    instance:
    let
      cluster_name = instance.cluster.NETWORK.cluster_name;
      instanceBaseDir = "${cfg.dataDir}/${cluster_name}";
      inherit (cfg) installDir;

      entrypoint = writeShellScript "entrypoint.sh" ''
        install_dir="${cfg.installDir}"
        cluster_name="${cluster_name}"
        dontstarve_dir="${cfg.dataDir}"

        function fail()
        {
        	echo Error: "$@" >&2
        	exit 1
        }

        function check_for_file()
        {
        	if [ ! -e "$1" ]; then
        		fail "Missing file: $1"
        	fi
        }


        check_for_file "${instanceBaseDir}/cluster.ini"
        check_for_file "${instanceBaseDir}/cluster_token.txt"
        check_for_file "${instanceBaseDir}/Master/server.ini"
        check_for_file "${instanceBaseDir}/Caves/server.ini"


        check_for_file "${installDir}/bin64"

        cd "$install_dir/bin64" || fail

        run_shared=(./dontstarve_dedicated_server_nullrenderer_x64)
        run_shared+=(-console)
        run_shared+=(-cluster "$cluster_name")
        run_shared+=(-monitor_parent_process $$)

        "$\{run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /' &
        "$\{run_shared[@]}" -shard Master | sed 's/^/Master: /'
      '';
    in
    {
      "dst-server@${cluster_name}" = {
        description = "DST Server instance ${cluster_name}";

        # we have a single update service that keeps us up to date from the steam
        # cmd control server, so we can wait for it to finish installing and
        # verifying whenever we restart services.
        after = [
          "network.target"
          "dst-steamcmd-update.service"
        ];

        wantedBy = [ "multi-user.target" ];

        preStart = ''
          mkdir -p ${instanceBaseDir}/Master ${instanceBaseDir}/Caves
          chmod +x ${entrypoint}        
          chown -R ${cfg.userName}:${cfg.groupName} ${instanceBaseDir}
        '';

        serviceConfig = {
          ExecStart = "${entrypoint}";
          User = "dstserver";
          Group = "dstserver";
          WorkingDirectory = instanceBaseDir;
          Restart = "on-failure";
        };
      };
    };

in
{
  imports = [ ./update.nix ];

  options.services.dstserver = {
    instances = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            # Configurations for the CAVE shard
            caves = {
              server = {
                NETWORK = {
                  server_port = 11001;
                };
                SHARD = {
                  is_master = false;
                  name = "Caves";
                };
                STEAM = {
                  master_server_port = 27019;
                  authentication_port = 8769;
                };
              };
            };

            # Configurations for the master shard (Overworld, typically)
            master = {
              server = {
                NETWORK = {
                  server_port = 11000;
                };
                SHARD = {
                  is_master = true;
                  name = "Caves";
                };
                STEAM = {
                  master_server_port = 27018;
                  authentication_port = 8768;
                };
              };
            };

            # Configurations for the cluster itself, since it
            # will be coordinating and overseeing our shards.
            cluster = {
              GAMEPLAY = {
                game_mode = "survival";
                max_players = 12;
                pvp = false;
                pause_when_empty = true;
              };

              NETWORK = {
                cluster_description = "We be starving out here";
                cluster_name = mkOption {
                  type = types.str;
                  description = ''
                    some cluster name for the server.
                  '';
                };
                cluster_password = "yippee";
              };

              MISC = {
                console_enabled = true;
              };

              SHARD = {
                shard_enabled = true;
                bind_ip = "127.0.0.1";
                master_ip = "127.0.0.1";
                master_port = 10889;
                cluster_key = "supersecretkey";
              };
            };
          };
        }
      );
      default = [ ];
      description = "List of DST service instances";
    };
  };

  config = mkIf (cfg.instances != [ ]) {
    users.users.${cfg.userName} = {
      isSystemUser = true;
      group = cfg.groupName;
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups.${cfg.groupName} = { };

    systemd.services = lib.foldlAttrs (
      acc: instanceName: instCfg:
      acc // makeInstanceService instCfg
    ) { } (lib.listToAttrs (map (i: nameValuePair i.cluster.NETWORK.cluster_name i) cfg.instances));
  };
}
