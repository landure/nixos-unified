/**
  # Documentations

  This module installs:

  - man pages
  - cheatsheets:
    - cheat.sh
    - tldr
  - full NixOS, packages, and development documentation.

  - [cheat.sh homepage](https://cht.sh/)
    ([cheat.sh @ GitHub](https://github.com/chubin/cheat.sh)).
  - [tldr pages homepage](https://tldr.sh/).
  - [Tealdeer homepage](https://tealdeer-rs.github.io/tealdeer/)
    ([Tealdeer @ GitHub](https://github.com/tealdeer-rs/tealdeer)).
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.lists) flatten optionals;
  inherit (lib.types) bool;
  inherit (lib.modules) mkIf mkDefault mkEnableOption;

  cfg = config.biapy.nixos-unified.nixos.console.docs;

in
{
  options = {
    biapy.nixos-unified.nixos.console.docs = {
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

      full-doc = mkEnableOption "full documentation (NixOS, packages, and developers)";
    };

    config = mkIf cfg.enable {
      environment.defaultPackages =
        with pkgs;
        flatten [
          (optionals cfg.man-pages)
          [
            man-pages
            man-pages-posix
          ]
          (optionals cfg.cheat-sheats)
          [
            cht-sh # command-line interface for the Cheat.sh service
            tealdeer # `tldr` A very fast implementation of tldr in Rust
          ]
        ];

      documentation = {
        # install documentation of packages from environment.systemPackages into the generated system path.
        enable = mkDefault true;

        # install info pages and the info command. This also includes "info" outputs.
        info.enable = mkDefault true;

        # install manual pages.
        man = {
          enable = mkDefault cfg.man-pages.enable; # enable manual pages and the man command.

          # generate the manual page index caches using mandb(8).
          # This allows searching for a page or keyword using utilities like apropos(1).
          generateCaches = mkDefault true;

          man-db.enable = mkDefault true;
        };

        # install documentation targeted at developers.
        dev.enable = mkDefault cfg.full-docs;

        # install documentation distributed in packages' /share/doc.
        doc.enable = mkDefault cfg.full-docs;

        # install NixOS's own documentation.
        nixos.enable = mkDefault cfg.full-docs;
      };
    };

  };
}
