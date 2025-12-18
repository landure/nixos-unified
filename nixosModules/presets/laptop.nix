/**
  # Laptop preset
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.presets.console;

in
{
  options = {
    biapy.nixos-unified.nixos.presets.console = {
      enable = mkEnableOption "Laptop presets";
    };
  };

  config = mkIf cfg.enable {
    biapy.nixos-unified.nixos = {
      presets.console = mkDefault true;
      system.power-management.enable = mkDefault true;
    };
  };
}
