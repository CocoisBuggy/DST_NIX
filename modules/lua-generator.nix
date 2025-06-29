{ lib, pkgs }:

let
  toLua =
    value:
    if builtins.isAttrs value then
      "{ " + (lib.concatStringsSep ", " (lib.mapAttrsToList (k: v: "${k} = ${toLua v}") value)) + " }"
    else if builtins.isList value then
      "{ " + (lib.concatStringsSep ", " (map toLua value)) + " }"
    else if builtins.isString value then
      ''"${value}"''
    else if builtins.isBool value then
      if value then "true" else "false"
    else if builtins.isInt value then
      toString value
    else
      throw "Unsupported type: ${builtins.typeOf value}";

  renderLuaFile = value: ''
    return ${toLua value}
  '';
in
{
  toLua = toLua;
  renderLuaFile = renderLuaFile;
}
