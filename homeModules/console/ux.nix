/**
  # command-line UX enhancements

  ## 🛠️ Tech Stack

  - [IntelliShell homepage](https://lasantosr.github.io/intelli-shell/)
    ([IntelliShell @ GitHub](https://github.com/lasantosr/intelli-shell)).
  - [McFly @ GitHub](https://github.com/cantino/mcfly).
  - [McFly fzf integration @ GitHub](https://github.com/bnprks/mcfly-fzf).
  - [Zellij homepage](https://zellij.dev/).
    ([Zellij @ GitHub](https://github.com/zellij-org/zellij)).

  ## 📝 Documentation

  - [programs.bash @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enable).
  - [programs.intelli-shell @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.intelli-shell.enable).
  - [programs.mcfly @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.mcfly.enable).
  - [programs.zellij @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zellij.enable).
  - [programs.zsh @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable).
  - [home.shell @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-home.shell.enableBashIntegration).

  ## 🙇 Acknowledgements

  - [Zellij documentation](https://zellij.dev/documentation/).
  - [Zellij default keybindings](https://github.com/zellij-org/zellij/blob/main/zellij-utils/assets/config/default.kdl).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.home-manager.console.ux;

  homeManagerSessionVars = "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";

in
{
  options = {
    biapy.nixos-unified.home-manager.console.ux = {
      enable = mkEnableOption "command-line UX enhancements";
    };
  };

  config = mkIf cfg.enable {

    home.shell = {
      enableBashIntegration = mkDefault true;
      enableZshIntegration = mkDefault true;
    };

    programs = {
      bash = {
        enable = mkDefault true;
        enableCompletion = mkDefault true;
        enableVteIntegration = mkDefault true;
        # bashrcExtra = ''
        #   # Load "''${HOME}/.config/bash/bashrc.bash"
        #   [[ -e "''${XDG_CONFIG_HOME:-"''${HOME}/.config"}/bash/bashrc.bash" ]] &&
        #     source "''${XDG_CONFIG_HOME:-"''${HOME}/.config"}/bash/bashrc.bash"
        # '';

        initExtra = ''
          [[ -f "${homeManagerSessionVars}" ]] && source "${homeManagerSessionVars}"
        '';
      };

      # `sk` Fuzzy Finder in rust!
      skim.enable = mkDefault true;
      fzf.enable = mkDefault true;

      # command template and snippet manager
      programs.intelli-shell = {
        enable = mkDefault true;

        # Configuration settings for intelli-shell.
        # See: https://github.com/lasantosr/intelli-shell/blob/main/default_config.toml.
        settings = {
          check_updates = mkDefault false;
          #data_dir = "/home/myuser/my/custom/datadir";
          # logs = {
          #   enabled = false;
          # };
          # theme = {
          #   accent = "yellow";
          #   comment = "italic green";
          #   error = "dark red";
          #   highlight = "darkgrey";
          #   highlight_accent = "yellow";
          #   highlight_comment = "italic green";
          #   highlight_primary = "default";
          #   highlight_secondary = "default";
          #   highlight_symbol = "» ";
          #   primary = "default";
          #   secondary = "dim";
          # };
        };

        # Settings for customizing the keybinding to integrate your shell with intelli-shell.
        # See: https://lasantosr.github.io/intelli-shell/guide/installation.html#customizing-shell-integration.
        # shellHotKeys = {
        #   bookmark_hotkey = "\\\\C-b";
        #   fix_hotkey = "\\\\C-p";
        #   search_hotkey = "\\\\C-t";
        #   skip_esc_bind = "\\\\C-q";
        #   variable_hotkey = "\\\\C-a";
        # };
      };

      # McFly replaces your default ctrl-r shell history search with an
      # intelligent search engine
      mcfly = {
        enable = mkDefault true;

        # enable fuzzy searching. 0 is off; higher numbers weight toward shorter matches.
        # Values in the 2-5 range get good results so far.
        fuzzySearchFactor = mkDefault 3;

        # enable McFly fzf integration.
        fzf.enable = mkDefault true;

        # Interface view to use.  one of "TOP", "BOTTOM"
        interfaceView = mkDefault "TOP";

        # Key scheme to use. one of "emacs", "vim".
        keyScheme = mkDefault "vim";

        # Settings written to ~/.config/mcfly/config.toml.
        # settings = '''';
      };

      # Zellij is a terminal multiplexer
      zellij = {
        enable = mkDefault true;
        attachExistingSession = mkDefault false;
        exitShellOnExit = mkDefault true;
        settings = {
          # @see https://zellij.dev/documentation/options
          show_startup_tips = mkDefault false;
          show_release_notes = mkDefault false;
          keybinds = {
            _children = [
              { unbind = "Ctrl q"; }
              {
                shared_except = {
                  _args = [ "locked" ];
                  _children = [
                    {
                      bind = {
                        _args = [ "Ctrl Alt Shift q" ];
                        _children = [ { Quit = { }; } ];
                      };
                    }
                  ];
                };
              }
            ];
          };
        };
      };

      zsh = {
        enable = mkDefault true;
        enableVteIntegration = mkDefault true;
        autosuggestion.enable = mkDefault true;
        oh-my-zsh.enable = mkDefault true;
      };
    };

  };
}
