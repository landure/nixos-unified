{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.facter) report;
  inherit (lib.lists) length;

  pci_hardware_available = length (report.hardware.pci or [ ]) > 0;
in
{
  config = mkIf pci_hardware_available { environment.defaultPackages = with pkgs; [ pciutils ]; };
}
