/**
  # Sound

  Enable Pipewire when sound devices are available.

  ## 🛠️ Tech Stack

  - [wiremix @ GitHub](https://github.com/tsowell/wiremix).

  ## 📝 Documentation

  - [services.pipewire @ NixOS reference](https://search.nixos.org/options?query=services.pipewire)
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
  inherit (config.facter) report;
  inherit (lib.lists) length;
  inherit (pkgs) wiremix;

  cfg = config.biapy.nixos-unified.nixos.hardware.sound;

  sound_available = length (report.hardware.sound or [ ]) > 0;
in
{
  options = {
    biapy.nixos-unified.nixos.hardware.sound = {
      enable = mkEnableOption "audio (sound) support";
    };
  };

  config = mkIf (cfg.enable && sound_available) {
    services = {
      # Disable pulseaudio
      pulseaudio.enable = mkDefault false;

      # Enable sound with pipewire
      pipewire = {
        enable = mkDefault true;
        alsa.enable = mkDefault true;
        alsa.support32Bit = mkDefault true;
        pulse.enable = mkDefault true;
        # If you want to use JACK apps, uncomment this
        # jack.enable = true;

        # use the example session manager (no others are packaged yet, so this is enable by default)
        # no need to redefine it in your config for now)
        # media-session.enable = true;
      };
    };

    environment.defaultPackages = [ wiremix ];
  };
}
