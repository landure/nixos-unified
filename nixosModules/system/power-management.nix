/**
  # Power management

  - [auto-cpufreq @ GitHub](https://github.com/AdnanHodzic/auto-cpufreq).
  - [TLP homepage](https://linrunner.de/tlp/)
    ([TLP @ GitHub](https://github.com/linrunner/TLP)).
  - [thermal daemon @ GitHub](https://github.com/intel/thermal_daemon).

  - [services.auto-cpufreq @ NixOS reference](https://search.nixos.org/options?query=services.auto-cpufreq).
  - [services.logind @ NixOS reference](https://search.nixos.org/options?query=services.logind).
  - [services.thermald @ NixOS reference](https://search.nixos.org/options?query=services.thermald).
  - [services.tlp @ NixOS reference](https://search.nixos.org/options?query=services.tlp).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.system.power-management;
in
{
  options = {
    biapy.nixos-unified.nixos.system.power-management.enable = mkEnableOption "ZSA keyboards";
  };

  config = mkIf cfg.enable {

    powerManagement.enable = mkDefault true;

    services = {
      thermald.enable = mkDefault true;

      # see https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221
      logind.lidSwitch = mkDefault "suspend-then-hibernate";

      auto-cpufreq = {
        enable = mkDefault true;
        settings = {
          battery = {
            governor = mkDefault "powersave";
            turbo = mkDefault "never";
          };
          charger = {
            governor = mkDefault "performance";
            turbo = mkDefault "auto";
          };
        };
      };

      tlp = {
        enable = mkDefault true;
        settings = mkDefault {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;

          #Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };
    };
  };
}
