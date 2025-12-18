/**
  # Bluetooth support

  - [bluez-tools @ GitHub](https://github.com/khvzak/bluez-tools).
  - [BlueTUI @ GitHub](https://github.com/pythops/bluetui).
  - [bluetuith @ GitHub](https://github.com/bluetuith-org/bluetuith).

  - [Bluetooth @ NixOS Wiki](https://nixos.wiki/wiki/Bluetooth).
  - [Bluetooth @ Official NixOS Wiki](https://wiki.nixos.org/wiki/Bluetooth).
  - [hardware.bluetooth @ NixOS reference](https://search.nixos.org/options?query=hardware.bluetooth).

  ### Blueman

  Blueman is a GTK+ Bluetooth Manager.

  - [Blueman @ GitHub](https://github.com/blueman-project/blueman).
  - [services.blueman @ NixOS reference](https://search.nixos.org/options?query=services.blueman).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf mkDefault;
in
{
  config = mkIf config.facter.detected.bluetooth.enable {
    environment.defaultPackages = with pkgs; [
      # gnome-bluetooth
      bluez-tools
      bluetui
      bluetuith
    ];

    hardware.bluetooth = {
      powerOnBoot = mkDefault true;
      settings = {
        General = {
          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = mkDefault true;

          # When enabled other devices can connect faster to us, however
          # the tradeoff is increased power consumption.
          # Defaults to 'false'.
          FastConnectable = mkDefault false;
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = mkDefault true;
        };
      };
    };

    # Alternative bluetooth manager
    # services.blueman.enable = mkDefault true;
  };
}
