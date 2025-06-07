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
    mkIf
    makeLibraryPath
    nameValuePair
    ;

  nixpkgs-2211 = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b";
    sha256 = "sha256-lHrKvEkCPTUO+7tPfjIcb7Trk6k31rz18vkyqmkeJfY=";
  };

  pkgs-old = import nixpkgs-2211 {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };

  makeInstanceService =
    instance:
    let
      cluster_name = instance.cluster.NETWORK.cluster_name;
      instanceBaseDir = "${cfg.dataDir}/${cluster_name}";
      inherit (cfg) installDir;

      entrypoint = writeShellScript "entrypoint.sh" ''
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

        echo $LD_LIBRARY_PATH

        check_for_file "${instanceBaseDir}/cluster.ini"
        check_for_file "${instanceBaseDir}/cluster_token.txt"
        check_for_file "${instanceBaseDir}/Master/server.ini"
        check_for_file "${instanceBaseDir}/Caves/server.ini"
        # validate binary location
        check_for_file "${installDir}/bin64"
        check_for_file "${installDir}/bin64/dontstarve_dedicated_server_nullrenderer_x64"

        run_shared=(${installDir}/bin64/dontstarve_dedicated_server_nullrenderer_x64)
        run_shared+=(-persistent_storage_root "${instanceBaseDir}/data")
        run_shared+=(-conf_dir "${instanceBaseDir}")
        run_shared+=(-cluster "${cluster_name}")
        run_shared+=(-monitor_parent_process $$)

        "''${run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /' &
        "''${run_shared[@]}" -shard Master | sed 's/^/Master: /'
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
          ${pkgs.uutils-coreutils-noprefix}/bin/mkdir -p ${instanceBaseDir}/Master ${instanceBaseDir}/Caves
          chown -R ${cfg.userName}:${cfg.groupName} ${instanceBaseDir}
        '';

        environment = {
          LD_LIBRARY_PATH = makeLibraryPath [
            pkgs-old.curlWithGnuTls
            pkgs.stdenv.cc.cc.lib
          ];
        };

        serviceConfig = {
          ExecStart = "${pkgs.steam-run}/bin/steam-run ${entrypoint}";
          User = "dstserver";
          Group = "dstserver";
          WorkingDirectory = instanceBaseDir;
          Restart = "on-failure";
        };
      };
    };

in
{
  imports = [
    ./update.nix
    ./config.nix
    ./options.nix
  ];

  config = mkIf (cfg.instances != [ ]) {
    users.users.${cfg.userName} = {
      isSystemUser = true;
      group = cfg.groupName;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.${cfg.groupName} = { };

    systemd.tmpfiles.rules = map (
      x:
      "d '${cfg.dataDir}/${x.cluster.NETWORK.cluster_name}' 0750 '${cfg.userName}' '${cfg.groupName}' -"
    ) cfg.instances;

    systemd.services = lib.foldlAttrs (
      acc: instanceName: instCfg:
      acc // makeInstanceService instCfg
    ) { } (lib.listToAttrs (map (i: nameValuePair i.cluster.NETWORK.cluster_name i) cfg.instances));
  };
}
