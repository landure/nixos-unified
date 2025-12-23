/**
  # Command-line text editors

  ## 🛠️ Tech Stack

  - [Helix homepage](https://helix-editor.com/)
    ([Helix @ GitHub](https://github.com/helix-editor/helix)).
  - [edit @ GitHub](https://github.com/microsoft/edit).
  - [micro homepage](https://micro-editor.github.io/)
    ([micro @ GitHub])(https://github.com/zyedidia/micro)).
  - [ne @ GitHub](https://github.com/vigna/ne/).

  ## 📝 Documentation

  - [programs.helix @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.helix.enable).
  - [programs.micro @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.micro.enable).
  - [programs.ne @ Home Manager Configuration Options](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ne.enable).

  ## 🙇 Acknowledgements

  - [Fresh homepage](https://sinelaw.github.io/fresh/)
    ([Fresh @ GitHub](https://github.com/sinelaw/fresh)).
  - [Tilde homepage](https://os.ghalkes.nl/tilde/)
    ([Tilde @ GitHub](https://github.com/gphalkes/tilde)).
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

  cfg = config.biapy.nixos-unified.home-manager.console.text-editors;
in
{
  options = {
    biapy.nixos-unified.home-manager.console.text-editors = {
      enable = mkEnableOption "command-line text editors";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ msedit ];

    programs = {
      helix.enable = mkDefault true;
      micro.enable = mkDefault true;
      ne.enable = mkDefault true;
    };
  };
}
