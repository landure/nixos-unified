/**
  # Server preset
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.presets.server;
in
{
  options = {
    biapy.nixos-unified.nixos.presets.server = {
      enable = mkEnableOption "Server presets";
    };
  };

  config = mkIf cfg.enable {
    biapy.nixos-unified.nixos = {
      system = {
        nix-sane-defaults.enable = mkDefault true;
      };

      console = {
        ergol.enable = mkDefault true;
        sudo.enable = mkDefault true;
        modern-cli.enable = mkDefault true;
      };

      services.openssh.enable = mkDefault true;
    };
  };
}
