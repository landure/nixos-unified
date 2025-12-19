/**
  # Windows System for Linux (WSL) preset
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.presets.wsl;

in
{
  options = {
    biapy.nixos-unified.nixos.presets.wsl = {
      enable = mkEnableOption "WSL presets";
    };
  };

  config = mkIf cfg.enable {
    biapy.nixos-unified.nixos = {
      presets.console.enable = mkDefault true;
    };
  };
}
