/**
  # Windows System for Linux (WSL) preset for NixOS WSL

  ## 🛠️ Tech Stack

  - [NixOS WSL homepage](https://nix-community.github.io/NixOS-WSL/)
    ([NixOS WSL @ GitHub](https://github.com/nix-community/NixOS-WSL)).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.presets.wsl;

in
{
  options = {
    biapy.nixos-unified.nixos.presets.wsl = {
      enable = mkEnableOption "WSL presets";

      defaultUser = mkOption {
        type = str;
        description = "Default UNIX user for";
      };
    };
  };

  config = mkIf cfg.enable {
    wsl.enable = mkDefault true;
    wsl.defaultUser = mkDefault cfg.defaultUser;

    # imports = [
    #   # include NixOS-WSL modules in non-flake setting
    #   <nixos-wsl/modules>
    # ];

    biapy.nixos-unified.nixos = {
      presets.console.enable = mkDefault true;
    };
  };
}
