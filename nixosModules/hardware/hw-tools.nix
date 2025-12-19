/**
  # Hardware tools

  Install tools for available hardware (USB, PCI, Bluetooth)

  ## 🛠️ Tech Stack

  ### Bluetooth

  - [bluez-tools @ GitHub](https://github.com/khvzak/bluez-tools).
  - [BlueTUI @ GitHub](https://github.com/pythops/bluetui).
  - [bluetuith @ GitHub](https://github.com/bluetuith-org/bluetuith).

  ### USB

  - [Linux USB Project homepage](http://www.linux-usb.org/).
  - [cyme @ GitHub](https://github.com/tuna-f1sh/cyme).

  ### AMD GPU

  - [amdgpu_top @ GitHub](https://github.com/Umio-Yasuno/amdgpu_top).
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
    amdgpu_top
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
  amdgpu_available = config.facter.detected.graphics.amd.enable;
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
      ])

      // (optional amdgpu_available [ amdgpu_top ]);

  };
}
