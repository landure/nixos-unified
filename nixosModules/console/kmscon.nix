/**
  # kmscon

  kmscon is a system console for linux.
  It does not depend on any graphics-server on your system (like X.org),
  but instead provides a raw console layer that can be used independently

  @see https://www.freedesktop.org/wiki/Software/kmscon/
  @see https://github.com/Aetf/kmscon
  @see https://search.nixos.org/options?channel=unstable&query=services.kmscon
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

  cfg = config.biapy.nixos-unified.nixos.console.kmscon;

  # Set custom compiler flags for kmscon,
  # to ensure compatibility between Zellij shortcuts and backspace key.
  zellijCompatibleKmscon = pkgs.kmscon.overrideAttrs {
    mesonFlags = [ "-Dbackspace_sends_delete=true" ];
  };
in
{
  options = {
    biapy.nixos-unified.nixos.console.kmscon.enable = mkEnableOption "kmscon";
  };

  config = mkIf cfg.enable {

    services.kmscon = {
      # Use kmscon as the virtual console instead of gettys
      enable = mkDefault true;

      package = mkDefault zellijCompatibleKmscon;

      # Configure keymap from xserver keyboard settings (not needed)
      useXkbConfig = mkDefault true;

      # Extra flags to pass to kmscon.
      extraOptions = mkDefault "--term xterm-256color";

      # Extra contents of the kmscon.conf file.
      # extraConfig = ''
      # font-size=14
      # '';

      # Fonts used by kmscon, in order of priority.
      fonts = [
        {
          name = "Fira Code Nerd Font";
          package = pkgs.nerd-fonts.fira-code;
        }
        {
          name = "JetBrains Nerd Font Mono";
          package = pkgs.nerd-fonts.jetbrains-mono;
        }
        {
          name = "Noto Sans Nerd Font Mono";
          package = pkgs.nerd-fonts.noto;
        }
        {
          name = "DejaVu Sans Nerd Font Mono";
          package = pkgs.nerd-fonts.dejavu-sans-mono;
        }
      ];

      # Whether to use 3D hardware acceleration to render the console.
      # hwRender = false;
    };
  };
}
