/**
  # Ergo-l

  Set Ergol keymap for console and graphical console

  - [Ergo-L homepage](https://ergol.org/).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.console.ergol;
in
{
  options = {
    biapy.nixos-unified.nixos.console.ergol = {
      enable = mkEnableOption "kmscon";

      variant = mkOption {
        type = enum [
          "ergol"
          "ergol_iso"
        ];
        default = "ergol";
        description = ''
          What ergol variant to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = mkDefault "fr";
      inherit (cfg) variant;
    };

    # Configure console keymap
    # console.keyMap = "fr";
    console.useXkbConfig = mkDefault true;
    services.kmscon.useXkbConfig = mkDefault true;
  };
}
