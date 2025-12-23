/**
  # OpenRGB & Razer devices support

  ## 🛠️ Tech Stack

  - [OpenRGB](https://openrgb.org/) is an Open source RGB lighting control
    that doesn't depend on manufacturer software.
  - [libratbag @ GitHub](https://github.com/libratbag/libratbag)
    is a DBus daemon to configure input devices, mainly gaming mice.
  - [Piper @ GitHub](https://github.com/libratbag/piper)
    is a GTK+ application to configure gaming mice.
    Piper is merely a graphical frontend to the `ratbagd` DBus daemon.

  ## 📝 Documentation

  - [services.hardware.openrgb @ NixOS reference](https://search.nixos.org/options?query=services.hardware.openrgb).
  - [services.ratbagd @ NixOS reference](https://search.nixos.org/options?query=services.ratbagd).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;
  inherit (pkgs) piper openrgb-with-all-plugins;

  cfg = config.biapy.nixos-unified.nixos.hardware.openrgb;
in
{
  options = {
    biapy.nixos-unified.nixos.hardware.openrgb = {
      enable = mkEnableOption "OpenRGB & Razer devices support";
    };
  };

  config = mkIf cfg.enable {

    services = {
      ratbagd.enable = mkDefault true;

      hardware.openrgb = {
        enable = mkDefault true;
        package = mkDefault openrgb-with-all-plugins;
      };
    };

    environment.defaultPackages = [ piper ];
  };
}
