/**
  # nixosConfigurations

  attrset of hosts configurations
*/
{ lib, ... }:
let
  inherit (lib.lists) map;
  inherit (lib.strings) match;
  inherit (lib.attrsets) attrNames filterAttrs;

  # List the directory contents
  contents = builtins.readDir ./.;

  # Filter for `.nix` files or directories
  isDirOrNixFile =
    name: value:
    value == "directory" || (match ".*\\.nix$" name && value == "regular") && name != "default.nix";

  # convert filename or dirname to path
  toPath = name: ./. + name;

  filenames = attrNames (filterAttrs isDirOrNixFile contents);

  imports = map toPath filenames;
in
{
  inherit imports;
}
