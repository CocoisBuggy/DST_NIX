{
  lib,
  ...
}:
let
  inherit (lib) types mkOption;

  # Define the structure for a single mod or entry
  modOptions = types.submodule (
    { name, ... }:
    {
      options = {
        workshopId = mkOption {
          type = types.str;
          default = name;
        };
        name = mkOption {
          type = types.str;
          description = "Will be used to help keep the configs readable";
        };
        enabled = mkOption {
          type = types.bool;
          default = true;
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
    }
  );
in
{
  inherit modOptions;

  # example lua file that we would like to create
  # https://github.com/mathielo/dst-dedicated-server/blob/main/DSTClusterConfig/mods/modoverrides-custom.lua
  #
  # at this level we are not interested in the encoding, but we WILL try and help
  # the little luagen unit do its job by being cognizant of how we are treating
  # lua as a little config language, NOT a programming language
  makeModOverrides =
    mods:
    lib.attrsets.foldAttrs (x: n: x // n) { } (
      lib.attrsets.mapAttrsToList (id: value: { "[\"workshop-${id}\"]" = value; }) mods
    );

  # Make the simple lua setup (dedicated_server_mods_setup.lua)
  # e.g https://github.com/mathielo/dst-dedicated-server/blob/main/DSTClusterConfig/mods/dedicated_server_mods_setup-custom.lua
  makeSetup =
    instance:
    lib.strings.concatStringsSep "\n" (
      lib.attrsets.mapAttrsToList (id: value: ''
        -- Mod: ${value.name}
        ServerModSetup("${value.workshopId}")
      '') instance.mods
    );
}
