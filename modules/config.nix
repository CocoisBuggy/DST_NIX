{
  config,
  lib,
  pkgs,
  ...
}: # Add pkgs to the function arguments
let
  luaGen = import ./lua-generator.nix { inherit lib; };
  modConfig = import ./mods.nix { inherit lib; };
  cfg = config.services.dstserver;
  inherit (lib) mkIf;

  instanceConfig = instance: idx: {
    inherit (instance)
      name
      cluster_token
      overrides
      mods
      ;

    master.ini = {
      NETWORK = {
        server_port = 10999 + idx;
      };
      STEAM = {
        master_server_port = 27016 + idx;
        authentication_port = 8868 + idx;
      };
      SHARD = {
        is_master = true;
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
      SHARD = {
        is_master = false;
        name = "Caves";
      };
    };

    cluster = {
      GAMEPLAY = {
        game_mode = instance.gameMode;
        max_players = instance.maxPlayers;
        pvp = instance.pvp;
        pause_when_empty = instance.pauseWhenEmpty;
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

  # New helper function to write content to a Nix store path
  writeDstFile = instanceName: filename: content: pkgs.writeText "${instanceName}-${filename}" content;

in
{
  config = mkIf (cfg.instances != [ ]) {
    systemd.tmpfiles.rules =
      (map (
        instance: "d ${cfg.dataDir}/${instance.name}/Master 0774 '${cfg.userName}' '${cfg.groupName}' -"
      ) cfg.instances)
      ++ (map (
        instance: "d ${cfg.dataDir}/${instance.name}/Caves 0774 '${cfg.userName}' '${cfg.groupName}' -"
      ) cfg.instances)
      ++ (map (
        instance: "d ${cfg.dataDir}/${instance.name}/mods 0774 '${cfg.userName}' '${cfg.groupName}' -"
      ) cfg.instances)

      # Use the 'L' (symlink) type to link to the generated file in the Nix store
      # Or 'f+' with a copy command if you really want a copy on disk
      ++ map (
        instance:
        let
          iniContent = lib.generators.toINI { } instance.cluster;
          iniPath = writeDstFile instance.name "cluster.ini" iniContent;
        in
        "L ${cfg.dataDir}/${instance.name}/cluster.ini - - - - ${iniPath}"
      ) mappedInstances
      # every instance needs a reference to its cluster token
      ++ (map (
        instance:
        let
          tokenContent = lib.strings.trim instance.cluster_token;
          tokenPath = writeDstFile instance.name "cluster_token.txt" tokenContent;
        in
        "L ${cfg.dataDir}/${instance.name}/cluster_token.txt - - - - ${tokenPath}"
      ) mappedInstances)

      # Master server.ini
      ++ (map (
        instance:
        let
          iniContent = lib.generators.toINI { } instance.master.ini;
          iniPath = writeDstFile instance.name "Master-server.ini" iniContent;
        in
        "L ${cfg.dataDir}/${instance.name}/Master/server.ini - - - - ${iniPath}"
      ) mappedInstances)
      # Caves server.ini
      ++ (map (
        instance:
        let
          iniContent = lib.generators.toINI { } instance.caves.ini;
          iniPath = writeDstFile instance.name "Caves-server.ini" iniContent;
        in
        "L ${cfg.dataDir}/${instance.name}/Caves/server.ini - - - - ${iniPath}"
      ) mappedInstances)

      # The lua override is a bit more of a trick.
      ++ (map (
        instance:
        let
          luaContent = luaGen.renderLuaFile instance.overrides.master;
          luaPath = writeDstFile instance.name "Master-worldgenoverride.lua" luaContent;
        in
        "L ${cfg.dataDir}/${instance.name}/Master/worldgenoverride.lua - - - - ${luaPath}"
      ) mappedInstances)

      ++ (map (
        instance:
        let
          luaContent = luaGen.renderLuaFile instance.overrides.caves;
          luaPath = writeDstFile instance.name "Caves-worldgenoverride.lua" luaContent;
        in
        "L ${cfg.dataDir}/${instance.name}/Caves/worldgenoverride.lua - - - - ${luaPath}"
      ) mappedInstances)

      # MODS
      ++ (map (
        instance:
        let
          luaContent = luaGen.renderLuaFile (modConfig.makeModOverrides instance.mods);
          luaPath = writeDstFile instance.name "Mods-override.lua" luaContent;
        in
        "L ${cfg.dataDir}/${instance.name}/mods/modoverrides.lua - - - - ${luaPath}"
      ) mappedInstances)
      ++ (map (
        instance:
        let
          luaContent = modConfig.makeSetup instance;
          luaPath = writeDstFile instance.name "Mods-setup.lua" luaContent;
        in
        "L ${cfg.dataDir}/${instance.name}/mods/dedicated_server_mods_setup.lua - - - - ${luaPath}"
      ) mappedInstances);
  };
}
