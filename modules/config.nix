{
  config,
  lib,
  pkgs,
  ...
}: # Add pkgs to the function arguments
let
  luaGen = import ./lua-generator.nix { inherit lib pkgs; };
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
  writeDstFile =
    instanceName: filename: content:
    pkgs.writeText "${instanceName}-${filename}" content;

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

      # For each mapped instance, we now generate a list containing two rules:
      # 1. 'r': Remove the symlink if it exists.
      # 2. 'L': Create the new symlink.
      # The lib.flatten will turn our list of lists into the single flat list that tmpfiles.rules expects.
      ++ (lib.flatten (
        map (
          instance:
          let
            iniContent = lib.generators.toINI { } instance.cluster;
            iniPath = writeDstFile instance.name "cluster.ini" iniContent;
            targetPath = "${cfg.dataDir}/${instance.name}/cluster.ini";
          in
          [
            "r ${targetPath}"
            "L ${targetPath} - - - - ${iniPath}"
          ]
        ) mappedInstances
      ))

      ++ (lib.flatten (
        map (
          instance:
          let
            tokenContent = lib.strings.trim instance.cluster_token;
            tokenPath = writeDstFile instance.name "cluster_token.txt" tokenContent;
            targetPath = "${cfg.dataDir}/${instance.name}/cluster_token.txt";
          in
          [
            "r ${targetPath}"
            "L ${targetPath} - - - - ${tokenPath}"
          ]
        ) mappedInstances
      ))

      # Master server.ini
      ++ (lib.flatten (
        map (
          instance:
          let
            iniContent = lib.generators.toINI { } instance.master.ini;
            iniPath = writeDstFile instance.name "Master-server.ini" iniContent;
            targetPath = "${cfg.dataDir}/${instance.name}/Master/server.ini";
          in
          [
            "r ${targetPath}"
            "L ${targetPath} - - - - ${iniPath}"
          ]
        ) mappedInstances
      ))

      # Caves server.ini
      ++ (lib.flatten (
        map (
          instance:
          let
            iniContent = lib.generators.toINI { } instance.caves.ini;
            iniPath = writeDstFile instance.name "Caves-server.ini" iniContent;
            targetPath = "${cfg.dataDir}/${instance.name}/Caves/server.ini";
          in
          [
            "r ${targetPath}"
            "L ${targetPath} - - - - ${iniPath}"
          ]
        ) mappedInstances
      ))

      # Master worldgenoverride.lua
      ++ (lib.flatten (
        map (
          instance:
          let
            luaContent = luaGen.renderLuaFile instance.overrides.master;
            luaPath = writeDstFile instance.name "Master-worldgenoverride.lua" luaContent;
            targetPath = "${cfg.dataDir}/${instance.name}/Master/worldgenoverride.lua";
          in
          [
            "r ${targetPath}"
            "L ${targetPath} - - - - ${luaPath}"
          ]
        ) mappedInstances
      ))

      # Caves worldgenoverride.lua
      ++ (lib.flatten (
        map (
          instance:
          let
            luaContent = luaGen.renderLuaFile instance.overrides.caves;
            luaPath = writeDstFile instance.name "Caves-worldgenoverride.lua" luaContent;
            targetPath = "${cfg.dataDir}/${instance.name}/Caves/worldgenoverride.lua";
          in
          [
            "r ${targetPath}"
            "L ${targetPath} - - - - ${luaPath}"
          ]
        ) mappedInstances
      ))

      # MODS override
      ++ (lib.flatten (
        map (
          instance:
          let
            luaContent = luaGen.renderLuaFile (modConfig.makeModOverrides instance.mods);
            luaPath = writeDstFile instance.name "Mods-override.lua" luaContent;
            targetPath = "${cfg.dataDir}/${instance.name}/mods/modoverrides.lua";
          in
          [
            "r ${targetPath}"
            "L ${targetPath} - - - - ${luaPath}"
          ]
        ) mappedInstances
      ))

      # MODS setup
      ++ (lib.flatten (
        map (
          instance:
          let
            luaContent = modConfig.makeSetup instance;
            luaPath = writeDstFile instance.name "Mods-setup.lua" luaContent;
            targetPath = "${cfg.dataDir}/${instance.name}/mods/dedicated_server_mods_setup.lua";
          in
          [
            "r ${targetPath}"
            "L ${targetPath} - - - - ${luaPath}"
          ]
        ) mappedInstances
      ));
  };
}
