{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.dstserver;
  inherit (lib)
    mkIf
    ;

  # Shell script to install/update Don't Starve Together using steamcmd
  steamCmdScript = pkgs.writeShellScript "steamcmd-dst-update" ''
    set -euo pipefail # Exit on error, undefined variable, or pipe failure
    export HOME="${cfg.dataDir}"
    mkdir -p "${cfg.installDir}"
    echo "Updating Don't Starve Together server in ${cfg.installDir}..."
    echo "Using HOME: $HOME"

    ${pkgs.steamcmd}/bin/steamcmd +login anonymous \
                                 +force_install_dir "${cfg.installDir}" \
                                 +app_update 343050 validate \
                                 +quit

    echo "SteamCMD update process finished."
  '';
in
{
  config = mkIf (cfg.instances != [ ]) {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0755 '${cfg.userName}' '${cfg.groupName}' -"
      "d '${cfg.installDir}' 0755 '${cfg.userName}' '${cfg.groupName}' -"
    ];

    systemd.services.dst-steamcmd-update = {
      description = "Don't Starve Together Server Install/Update via SteamCMD";
      after = [
        "network.target"
        "systemd-tmpfiles-setup.service"
      ];
      wantedBy = [ "multi-user.target" ];
      before = [ "dst-server.service" ];

      path = [
        pkgs.steamcmd
        pkgs.coreutils
      ];

      serviceConfig = {
        Type = "oneshot";
        User = cfg.userName;
        Group = cfg.groupName;
        ExecStart = "${steamCmdScript}";
        WorkingDirectory = cfg.dataDir;
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };
  };
}
