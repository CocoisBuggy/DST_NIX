{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dstserver;
  inherit (lib) mkIf;
in
{

  # example lua file that we would like to create
  # https://github.com/mathielo/dst-dedicated-server/blob/main/DSTClusterConfig/mods/modoverrides-custom.lua
  #
  # at this level we are not interested in the encoding, but we WILL try and help
  # the little luagen unit do its job by being cognizant of how we are treating
  # lua as a little config language, NOT a programminh language
  makeModConfig = instance: 0;
}
