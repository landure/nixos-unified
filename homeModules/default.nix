{ lib, ... }:
let
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.lists) filter;
  inherit (lib.strings) hasSuffix;

  # List all files recursively in the directory
  allFiles = listFilesRecursive ./.;

  # Filter for `.nix` files
  nixFiles = filter (path: hasSuffix ".nix" path && path != ./default.nix) allFiles;
in
{
  imports = nixFiles;
}
