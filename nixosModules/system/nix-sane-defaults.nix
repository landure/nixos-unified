/**
  Automatically run the garbage collector at a specific time.

  @see https://search.nixos.org/options?channel=unstable&query=nix.gc
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.system.nix-sane-defaults;
in
{
  options = {
    biapy.nixos-unified.nixos.system.nix-sane-defaults.enable = mkEnableOption "Sane Defaults";
  };

  config = mkIf cfg.enable {
    nix = {
      gc = {
        automatic = mkDefault true;
        options = mkDefault "--delete-older-than 7d";
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = mkDefault true;
      };
    };
  };
}
