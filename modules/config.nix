{
  config,
  lib,
  ...
}:
let
  cfg = config.services.dstserver;

  inherit (lib)
    mkIf
    ;
in
{
  config = mkIf (cfg.instances != [ ]) {
    # initialize the main cluster config
    systemd.tmpfiles.rules =
      (map (
        instance:
        "f /var/lib/dstserver/${instance.cluster.NETWORK.cluster_name}/cluster.ini 0750 '${cfg.userName}' '${cfg.groupName}' - ${
          lib.generators.toINI { } instance.cluster
        }"
      ) cfg.instances)
      # every instance needs a reference to its cluster token
      ++ (map (
        instance:
        "f /var/lib/dstserver/${instance.cluster.NETWORK.cluster_name}/cluster_token.txt 0750 '${cfg.userName}' '${cfg.groupName}' - ${instance.cluster_token}"
      ) cfg.instances);
  };
}
