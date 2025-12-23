/**
  # Documentations

  This module installs:

  - man pages
  - cheatsheets:
    - cheat.sh
    - tldr

  ## 🛠️ Tech Stack

  - [cheat.sh homepage](https://cht.sh/)
    ([cheat.sh @ GitHub](https://github.com/chubin/cheat.sh)).
  - [tldr pages homepage](https://tldr.sh/).
  - [Tealdeer homepage](https://tealdeer-rs.github.io/tealdeer/)
    ([Tealdeer @ GitHub](https://github.com/tealdeer-rs/tealdeer)).

  ## 📝 Documentation

  - [programs.man @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.man.enable).
  - [programs.tealdeer @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.tealdeer.enable).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.lists) optionals;
  inherit (lib.types) bool;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.home-manager.console.docs;

in
{
  options = {
    biapy.nixos-unified.home-manager.console.docs = {
      enable = mkEnableOption "documentation";

      man-pages = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to enable man pages.
        '';
      };

      cheat-sheats = mkOption {
        type = bool;
        default = true;
        description = ''
          Whether to enable cheatsheets (cht-sh, tldr).
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      # install manual pages.
      man = {
        # enable manual pages and the man command.
        enable = mkDefault cfg.man-pages;

        # generate the manual page index caches using mandb(8).
        # This allows searching for a page or keyword using utilities like apropos(1).
        generateCaches = mkDefault true;
      };

      tealdeer = {
        enable = mkDefault cfg.cheat-sheats;
        settings = {
          # Whether to enable auto-update.
          updates.auto_update = mkDefault true;
        };
      };
    };

    environment.defaultPackages = optionals cfg.cheat-sheats [
      # command-line interface for the Cheat.sh service
      pkgs.cht-sh
    ];
  };
}
