{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config.facter) report;
in
{
  config = mkIf report.hardware.pci { environment.defaultPackages = with pkgs; [ pciutils ]; };
}
