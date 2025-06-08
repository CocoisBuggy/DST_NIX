{
  config,
  lib,
  ...
}:
let
  luaGen = import ./lua-generator.nix { inherit lib; };
  cfg = config.services.dstserver;

  inherit (lib)
    mkIf
    ;

  file =
    instance: filename: content:
    "w ${cfg.dataDir}/${instance.cluster.NETWORK.cluster_name}/${filename} 0774 '${cfg.userName}' '${cfg.groupName}' - ${content}";
in
{
  config = mkIf (cfg.instances != [ ]) {
    # initialize the main cluster config
    systemd.tmpfiles.rules =
      (map (
        instance:
        "d ${cfg.dataDir}/${instance.cluster.NETWORK.cluster_name}/Master 0774 '${cfg.userName}' '${cfg.groupName}' -"
      ) cfg.instances)
      ++ (map (
        instance:
        "d ${cfg.dataDir}/${instance.cluster.NETWORK.cluster_name}/Caves 0774 '${cfg.userName}' '${cfg.groupName}' -"
      ) cfg.instances)
      ++ map (
        instance: file instance "cluster.ini" (lib.generators.toINI { } instance.cluster)
      ) cfg.instances
      # every instance needs a reference to its cluster token
      ++ (map (
        instance: file instance "cluster_token.txt" (lib.strings.trim instance.cluster_token)
      ) cfg.instances)

      # We want to write the master and cave shard server configs, which consists of an ini and a lua script
      ++ (map (
        instance: file instance "Master/server.ini" (lib.generators.toINI { } instance.master.ini)
      ) cfg.instances)
      ++ (map (
        instance: file instance "Caves/server.ini" (lib.generators.toINI { } instance.caves.ini)
      ) cfg.instances)

      # The lua override is a bit more of a trick.
      ++ (map (
        instance: file instance "Master/worldgenoverride.lua" (luaGen.renderLuaFile instance.master.lua)
      ) cfg.instances)
      ++ (map (
        instance: file instance "Caves/worldgenoverride.lua" (luaGen.renderLuaFile instance.caves.lua)
      ) cfg.instances);
  };
}
