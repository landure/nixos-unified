/**
  # Automatic system upgrades

  To manually start auto-upgrade:

  ```bash
  sudo systemctl start nixos-upgrade.service
  ```

  To inspect auto-upgrade results:

  ```bash
  sudo journalctl --unit nixos-upgrade.service
  ```

  - [Automatic system upgrades @ NixOS Wiki](https://nixos.wiki/wiki/Automatic_system_upgrades).
  - [system.autoUpgrade @ NixOS reference](https://search.nixos.org/options?query=system.autoUpgrade).
  - [Keeping a NixOS system up-to-date @ Zander Otavka](https://zanderotavka.com/blog/2024/07/08/keeping-a-nixos-system-up-to-date/).
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
