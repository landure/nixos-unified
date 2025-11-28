{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption mkDefault;
  inherit (lib.attrsets) attrValues;
  inherit (lib.types) bool attrsOf package;
  inherit (lib.modules) mkIf;

  cfg = config.biapy.nixos-unified.nixos.modern-cli;

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
    biapy.nixos-unified.nixos.modern-cli = {
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

    programs.zoxide.enable = mkDefault true;
  };

}
