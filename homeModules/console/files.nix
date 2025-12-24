/**
  # Files TUI tools

  ## 🛠️ Tech Stack

  - [ag, The Silver Searcher @ GitHub](https://github.com/ggreer/the_silver_searcher).
  - [amber @ GitHub](https://github.com/dalance/amber).
  - [ast-grep homepage](https://ast-grep.github.io/).
    ([ast-grep (sg) @ GitHub](https://github.com/ast-grep/ast-grep)).
  - [bat @ GitHub](https://github.com/sharkdp/bat).
  - [dust @ GitHub](https://github.com/bootandy/dust).
  - [f2 homepage](https://f2.freshman.tech/)
    ([f2 @ GitHub](https://github.com/ayoisaiah/f2)).
  - [fd @ GitHub](https://github.com/sharkdp/fd).
  - [joshuto @ GitHub](https://github.com/kamiyaa/joshuto).
  - [LSD (LSDeluxe) @ GitHub](https://github.com/lsd-rs/lsd).
  - [moor @ GitHub](https://github.com/walles/moor).
  - [ov homepage](https://noborus.github.io/ov/)
    ([ov @ GitHub](https://github.com/noborus/ov)).
  - [ripgrep @ GitHub](https://github.com/BurntSushi/ripgrep).
  - [tuc @ GitHub](https://github.com/riquito/tuc).
  - [yazi homepage](https://yazi-rs.github.io/)
    ([yazi @ GitHub](https://github.com/sxyazi/yazi)).
  - [zoxide @ GitHub](https://github.com/ajeetdsouza/zoxide).

  ## 📝 Documentation

  - [programs.amber @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.amber.enable).
  - [programs.bat @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable).
  - [programs.fd @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable).
  - [programs.joshuto @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.joshuto.enable).
  - [programs.lsd @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lsd.enable).
  - [programs.ripgrep @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ripgrep.enable).
  - [programs.yazi @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.yazi.enable).
  - [programs.zoxide @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zoxide.enable).
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

  cfg = config.biapy.nixos-unified.home-manager.console.files;
in
{
  options = {
    biapy.nixos-unified.home-manager.console.files = {
      enable = mkEnableOption "command-line files TUI tools";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      ast-grep # Code searching tool
      dust # du alternative
      f2 # Batch file renamer
      moor # golang pager
      ov # Feature-rich terminal-based text viewer
      silver-searcher # ag, ack alternative
      tuc # cut drop-in replacement writen in Rust
    ];

    # Let Home Manager install and manage itself.
    programs = {
      amber.enable = mkDefault true;

      # `rg`: line-oriented search tool that recursively searches the current directory for a regex pattern
      ripgrep.enable = mkDefault true;

      fd.enable = mkDefault true;
      bat.enable = mkDefault true;
      joshuto.enable = mkDefault true;

      # `lsd` The next gen ls command
      lsd.enable = mkDefault true;

      yazi.enable = mkDefault true;

      # `z` is a smarter cd command, inspired by z and autojump.
      zoxide.enable = mkDefault true;
    };
  };
}
