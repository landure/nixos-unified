/**
  # No sleep

  Prevent system from sleeping by disabling related systemd targets.

  Useful for servers.
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.system.nix-sane-defaults;
in
{
  options = {
    biapy.nixos-unified.nixos.system.no-sleep.enable = mkEnableOption "No sleep mode";
  };

  config = mkIf cfg.enable {
    systemd.targets = {
      sleep.enable = mkDefault false;
      suspend.enable = mkDefault false;
      hibernate.enable = mkDefault false;
      hybrid-sleep.enable = mkDefault false;
    };
  };
}
