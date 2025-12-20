/**
  # Screen Backlight control

  ## 📝 Documentation

  - [programs.light @ NixOS reference](https://search.nixos.org/options?query=programs.light).
  @see https://search.nixos.org/options?&query=services.actkbd

  ## 🙇 Acknowledgements

  - [Sway @ NixOS Wiki](https://nixos.wiki/wiki/Sway).
  - [Backlight @ ArchLinux Wiki](https://wiki.archlinux.org/title/Backlight).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.attrsets) mapAttrs;

  cfg = config.biapy.nixos-unified.nixos.hardware.backlight;
in
{
  options = {
    biapy.nixos-unified.nixos.hardware.backlight = {
      enable = mkEnableOption "Screen backlight control";
    };
  };

  config = mkIf cfg.enable {
    # Add all users to "video" group.
    users.users = mapAttrs (username: _: { ${username}.extraGroups = [ "video" ]; }) config.users.users;

    programs.light.enable = mkDefault true;
  };
}
