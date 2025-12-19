/**
  # Hardware tools

  Install tools for available hardware (USB, PCI, Bluetooth)

  ## USB

  - [Linux USB Project homepage](http://www.linux-usb.org/).
  - [cyme @ GitHub](https://github.com/tuna-f1sh/cyme).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (config.facter) report;
  inherit (lib.lists) length optional;
  inherit (pkgs)
    bluez-tools
    bluetui
    bluetuith
    pciutils
    usbutils
    cyme
    ;

  cfg = config.biapy.nixos-unified.nixos.hardware.hw-tools;

  pci_available = length (report.hardware.pci or [ ]) > 0;
  usb_available = length (report.hardware.usb or [ ]) > 0;
  bluetooth_available = config.facter.detected.bluetooth.enable;
in
{
  options = {
    biapy.nixos-unified.nixos.hardware.hw-tools = {
      enable = mkEnableOption "harware tools (USB, PCI, Bluetooth)";
    };
  };

  config = mkIf cfg.enable {

    environment.defaultPackages =
      (optional pci_available [ pciutils ])
      // (optional usb_available [
        usbutils
        cyme
      ])
      // (optional bluetooth_available [
        bluez-tools
        bluetui
        bluetuith
      ]);
  };
}
