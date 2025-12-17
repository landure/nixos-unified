/**
  # Console (TUI) preset
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
      enable = mkEnableOption "console presets";
    };
  };

  config = mkIf cfg.enable {
    biapy.nixos-unified.nixos = {
      system = {
        nix-sane-defaults.enable = mkDefault true;
        autoUpgrade.enable = mkDefault true;
        power-management.enable = mkDefault true;
      };

      console = {
        docs.enable = mkDefault true;
        sudo.enable = mkDefault true;
        modern-cli.enable = mkDefault true;
        kmscon.enable = mkDefault true;
      };

      services.openssh.enable = mkDefault true;
    };
  };
}
