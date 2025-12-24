/**
  # Media Tools

  ## 🛠️ Tech Stack

  - [Cava homepage](https://github.com/karlstav/cava).
  - [castero @ GitHub](https://github.com/xgi/castero).
  - [mpv homepage](https://mpv.io/)
    ([mpv @ GitHub](https://github.com/mpv-player/mpv)).
  - [pamixer @ GitHub](https://github.com/cdemoulins/pamixer).
  - [pulsemixer @ GitHub](https://github.com/GeorgeFilipkin/pulsemixer).
  - [PyRadio @ GitHub](https://github.com/coderholic/pyradio).
  - [radio-active @ GitHub](https://github.com/deep5050/radio-active).
  - [radio-cli @ GitHub](https://github.com/margual56/radio-cli).
  - [yt-dlp @ GitHub](https://github.com/yt-dlp/yt-dlp).
  - [wiremix @ GitHub](https://github.com/tsowell/wiremix).

  ## 📝 Documentation

  - [programs.cava @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.cava.enable).
  - [programs.mpv @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mpv.enable).
  - [programs.radio-active @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.radio-active.enable).
  - [programs.yt-dlp @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yt-dlp.enable).
  - [cava @ Stylix](https://nix-community.github.io/stylix/options/modules/cava.html).

  ## 🙇 Acknowledgements

  - [mpv Wiki](https://github.com/mpv-player/mpv/wiki).
  - [mpv @ Official NixOS Wiki](https://wiki.nixos.org/wiki/MPV).
  - [MPV @ NixOS Wiki](https://nixos.wiki/wiki/MPV).
  - [mpvScripts @ NixOS' Packages](https://search.nixos.org/packages?query=mpvScripts).
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
  inherit (pkgs) mpv-unwrapped mpvScripts ffmpeg-full;

  cfg = config.biapy.nixos-unified.home-manager.console.media;

in
{
  options = {
    biapy.nixos-unified.home-manager.console.media = {
      enable = mkEnableOption "command-line media tools";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      castero # Podcast player
      wiremix # Pipewire mixer
      # pamixer
      pulsemixer
      pyradio
    ];

    programs = {
      # Cross-platform Audio Visualizer
      cava.enable = mkDefault true;

      mpv = {
        enable = true;

        package = mpv-unwrapped.wrapper {
          mpv = mpv-unwrapped.override {
            ffmpeg = ffmpeg-full;
            waylandSupport = mkDefault true;
            vapoursynthSupport = mkDefault true;
            sixelSupport = mkDefault true;
          };

          scripts = with mpvScripts; [
            uosc
            sponsorblock
            mpris
          ];

          youtubeSupport = mkDefault true;
        };

        bindings = {
          # @see https://mpv.io/manual/stable/#input-key-bindings
          "j" = "seek -5";
          "k" = "seek +5";
          "h" = "seek -1";
          "l" = "seek +1";
          "space" = "cycle pause";
          "q" = "quit";

          WHEEL_UP = "seek 10";
          WHEEL_DOWN = "seek -10";
          "Alt+0" = "set window-scale 0.5";

        };

        config = {
          profile = mkDefault "gpu-hq";
          force-window = mkDefault true;
          ytdl-format = mkDefault "bestvideo+bestaudio";
          cache-default = mkDefault 4000000;
        };
        defaultProfiles = [
          "gpu-hq"
          "high-quality"
        ];
      };

      radio-active.enable = mkDefault true;

      radio-cli = {
        enable = mkDefault true;
        settings = {
          config_version = "2.3.0";
          country = mkDefault "FR";
          data = builtins.attrValues (
            builtins.mapAttrs
              (station: url: {
                inherit station;
                inherit url;
              })
              {
                "Lofi Girl 🎶" = "https://www.youtube.com/live/jfKfPfyJRdk?si=WDl-XdfuhxBfe6XN";
                "Nostalgie 🎶🇫🇷" = "https://streaming.nrjaudio.fm/oug7girb92oc";
                "France Inter 🇫🇷" = "https://icecast.radiofrance.fr/franceinter-midfi.mp3";
                "France Info 🇫🇷" = "https://icecast.radiofrance.fr/franceinfo-midfi.mp3";
                "France Bleu Breizh Izel 🇫🇷" = "https://icecast.radiofrance.fr/fbbreizizel-midfi.mp3";
              }
          );
          max_lines = mkDefault 7;
        };
      };

      yt-dlp = {
        enable = mkDefault true;

        settings = {
          embed-thumbnail = mkDefault true;
          embed-subs = mkDefault true;
          sub-langs = mkDefault "en,fr";
          downloader = mkDefault "aria2c";
          downloader-args = mkDefault "aria2c:'-c -x8 -s8 -k1M'";
        };
      };
    };
  };
  stylix.targets.cava.rainbow.enable = mkDefault true;

}
