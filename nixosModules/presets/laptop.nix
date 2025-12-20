/**
  # Laptop preset
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.presets.laptop;
in
{
  options = {
    biapy.nixos-unified.nixos.presets.laptop = {
      enable = mkEnableOption "Laptop preset";
    };
  };

  config = mkIf cfg.enable {
    biapy.nixos-unified.nixos = {
      presets.console.enable = mkDefault true;
      system.power-management.enable = mkDefault true;
      hardware = {
        backlight.enable = mkDefault true;
        hw-tools.enable = mkDefault true;
        sound.enable = mkDefault true;
      };
    };
  };
}
