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
      system.nix-sane-defaults = mkDefault true;

      console = {
        docs = mkDefault true;
        sudo = mkDefault true;
        modern-cli = mkDefault true;
        kmscon = mkDefault true;
      };

      services.openssh.enable = mkDefault true;
    };

  };
}
