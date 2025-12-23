/**
  # nixosConfigurations

  attrset of hosts configurations
*/
{ lib, ... }@inputs:
let
  inherit (lib.lists) map;
  inherit (lib.strings) match;
  inherit (lib.attrsets) attrNames filterAttrs mergeAttrsList;

  # List the directory contents
  contents = builtins.readDir ./.;

  # Filter for `.nix` files or directories
  isDirOrNixFile =
    name: value:
    (value == "directory" || ((null != match ".*\\.nix$" name) && value == "regular"))
    && name != "default.nix";

  # convert filename or dirname to path
  toPath = name: ./. + ("/" + name);

  filenames = attrNames (filterAttrs isDirOrNixFile contents);

  hostImports = map toPath filenames;

  hostConfigurations = map (hostImport: import hostImport inputs) hostImports;
in
mergeAttrsList hostConfigurations
