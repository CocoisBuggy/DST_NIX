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

  instanceConfig = instance: idx: {
    name = instance.name;

    master.ini = {
      NETWORK = {
        server_port = 10999 + idx;
      };
      STEAM = {
        master_server_port = 27016 + idx;
        authentication_port = 8768 + idx;
      };
    };

    caves.ini = {
      NETWORK = {
        server_port = 11018 - idx;
      };
      STEAM = {
        master_server_port = 28016 + idx;
        authentication_port = 8768 + idx;
      };
    };

    cluster = {
      GAMEPLAY = {
        game_mode = instance.gameMode; #  "survival";
        max_players = instance.maxPlayers; #  6;
        pvp = instance.pvp; #  false;
        pause_when_empty = instance.pauseWhenEmpty; #  true;
      };

      NETWORK = {
        cluster_description = instance.description;
        cluster_name = instance.name;
        cluster_password = instance.password;
      };

      MISC = {
        console_enabled = true;
      };

      SHARD = {
        shard_enabled = true;
        bind_ip = "127.0.0.1";
        master_ip = "127.0.0.1";
        master_port = 10888 + idx;
        cluster_key = "supersecretkey";
      };
    };
  };

  mappedInstances = map (x: instanceConfig x.value x.index) (
    builtins.genList (i: {
      index = i;
      value = builtins.elemAt cfg.instances i;
    }) (builtins.length cfg.instances)
  );

  file =
    instance: filename: content:
    "f+ ${cfg.dataDir}/${instance.name}/${filename} 0774 '${cfg.userName}' '${cfg.groupName}' - ${content}";
in
{
  config = mkIf (cfg.instances != [ ]) {
    # initialize the main cluster config
    systemd.tmpfiles.rules =
      (map (
        instance: "d ${cfg.dataDir}/${instance.name}/Master 0774 '${cfg.userName}' '${cfg.groupName}' -"
      ) cfg.instances)
      ++ (map (
        instance: "d ${cfg.dataDir}/${instance.name}/Caves 0774 '${cfg.userName}' '${cfg.groupName}' -"
      ) cfg.instances)
      ++ map (
        instance: file instance "cluster.ini" (lib.generators.toINI { } instance.cluster)
      ) mappedInstances
      # every instance needs a reference to its cluster token
      ++ (map (
        instance: file instance "cluster_token.txt" (lib.strings.trim instance.cluster_token)
      ) mappedInstances)

      # We want to write the master and cave shard server configs, which consists of an ini and a lua script
      ++ (map (
        instance: file instance "Master/server.ini" (lib.generators.toINI { } instance.master.ini)
      ) mappedInstances)
      ++ (map (
        instance: file instance "Caves/server.ini" (lib.generators.toINI { } instance.caves.ini)
      ) mappedInstances)

      # The lua override is a bit more of a trick.
      ++ (map (
        instance: file instance "Master/worldgenoverride.lua" (luaGen.renderLuaFile instance.overrides.master)
      ) mappedInstances)
      ++ (map (
        instance: file instance "Caves/worldgenoverride.lua" (luaGen.renderLuaFile instance.overrides.cave)
      ) mappedInstances);
  };
}
