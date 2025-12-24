/**
  # TUI log viewers

  ## 🛠️ Tech Stack

  - [lnav homepage](https://lnav.org/)
    ([lnav @ GitHub](https://github.com/tstack/lnav)).
  - [LazyJournal @ GitHub](https://github.com/Lifailon/lazyjournal).
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

  cfg = config.biapy.nixos-unified.home-manager.console.log-viewers;
in
{
  options = {
    biapy.nixos-unified.home-manager.console.log-viewers = {
      enable = mkEnableOption "command-line log viewers";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lnav # Log files viewer
      lazyjournal # TUI for journalctl, file system logs, as well Docker and Podman containers.
    ];
  };
}
