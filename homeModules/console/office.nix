/**
  # Office tools for the console.

  ## 🛠️ Tech Stack

  - [doxx @ GitHub](https://github.com/bgreenwell/doxx)
    is a fast, terminal-native document viewer for Word files.
  - [tdf @ GitHub](https://github.com/itsjunetime/tdf)
    is a terminal-based PDF viewer..

  ## 🙇 Acknowledgements

  - [Episode 619: The Trouble with TUIs @ Linux Unplugged](https://linuxunplugged.com/619).
  - [Doxx - Pour lire vos fichiers Word depuis le terminal @ Korben 🇫🇷](https://korben.info/doxx-terminal-viewer-word-rust.html).
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

  cfg = config.biapy.nixos-unified.home-manager.console.office;
in
{
  options = {
    biapy.nixos-unified.home-manager.console.office = {
      enable = mkEnableOption "command-line office tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      doxx
      tdf
    ];
  };
}
