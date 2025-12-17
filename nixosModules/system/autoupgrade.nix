/**
  # Automatic system upgrades

  - [Automatic system upgrades @ NixOS Wiki](https://nixos.wiki/wiki/Automatic_system_upgrades).
  - [system.autoUpgrade @ NixOS reference](https://search.nixos.org/options?query=system.autoUpgrade).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.system.autoUpgrade;
in
{
  options = {
    biapy.nixos-unified.nixos.system.autoUpgrade.enable = mkEnableOption "ZSA keyboards";
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = mkDefault true;

      flake = mkDefault "github:landure/nixos-unified";

      # Respect flake lock file.
      upgrade = mkDefault false;

      # Any additional flags passed to nixos-rebuild
      # flags = [
      #   "--print-build-logs"
      # ];

      dates = mkDefault "02:00";
      randomizedDelaySec = mkDefault "45min";

      # Default to switching to new kernel.
      operation = mkDefault "switch";

      runGarbageCollection = mkDefault true;
    };
  };
}
