/**
  # Desktop preset
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.presets.desktop;
in
{
  options = {
    biapy.nixos-unified.nixos.presets.desktop = {
      enable = mkEnableOption "Desktop presets";
    };
  };

  config = mkIf cfg.enable {
    biapy.nixos-unified.nixos = {
      presets.console.enable = mkDefault true;
      system.power-management.enable = mkDefault true;
      hardware = {
        hw-tools.enable = mkDefault true;
        sound.enable = mkDefault true;
      };

      desktop = {
        xdg.enable = true;
        flatpak.enable = true;
      };
    };

    # Add Udev rules for ZSA keyboards
    hardware.keyboard.zsa.enable = mkDefault true;
  };
}
