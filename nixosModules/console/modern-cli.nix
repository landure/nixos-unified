{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.attrsets) attrValues;
  inherit (lib.types) bool attrsOf package;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.console.modern-cli;

  # List of supported CLI tools and their package names
  cliTools = {
    inherit (pkgs)
      ripgrep # ripgrep (rg) (grep alternative)
      fd # fd-find
      bat # bat (cat alternative)
      eza # eza (ls alternative)
      procs # ps alternative
      btop # top alternative
      bottom # htop alternative
      superfile # file manager
      helix # text editor
      git # Git
      jq # jq (JSON processor)
      yq # yq (YAML processor)
      fzf # fzf (fuzzy finder)
      sd # sd (sed alternative)
      zellij # terminal multiplexer
      dust # du alternative
      duf # df alternative
      dog # DNS lookup
      grex # regex generator
      gum # shell script formatting
      ;
  };
in
{
  options = {
    biapy.nixos-unified.nixos.console.modern-cli = {
      enable = mkOption {
        type = bool;
        default = true;
        example = true;
        description = ''
          Whether to add modern command-line tools to nixOS `environment.systemPackages`.
        '';

      };

      packages = mkOption {
        type = attrsOf package;
        default = cliTools;

        description = ''
          Attribute set of CLI tools to install.
        '';
        example = ''
          packages = {
            inherit (pkgs.unstable) ripgrep;
          };
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = attrValues cfg.packages;

    programs = {
      bash.completion.enable = mkDefault true;

      zsh = {
        enable = mkDefault true;
        enableCompletion = mkDefault true;
        vteIntegration = mkDefault true;
        autosuggestions.enable = mkDefault true;
      };

      starship.enable = mkDefault true; # Enhanced command prompt

      # Install zoxide, lsdeluxe
      zoxide.enable = mkDefault true;

      skim.enable = mkDefault true; # `sk` Fuzzy Finder in rust!
      bat.enable = mkDefault true;

      # Install Pay Respects
      pay-respects.enable = mkDefault true;

      # Install git
      git.enable = mkDefault true;
    };
  };

}
