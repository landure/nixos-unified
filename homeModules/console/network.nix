/**
  # command-line network tools

  ## 🛠️ Tech Stack

  - [dog-community homepage](https://dog.ramfield.net/)
    ([dog-community @ GitHub](https://github.com/Dj-Codeman/dog_community))
  - [doggo homepage](https://doggo.mrkaran.dev/)
    ([doggo @ GitHub](https://github.com/mr-karan/doggo)).
  - [gping @ GitHub](https://github.com/orf/gping).

  ## 🙇 Acknowledgements

  - [dog @ GitHub](https://github.com/ogham/dog).
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

  cfg = config.biapy.nixos-unified.home-manager.console.network;
in
{
  options = {
    biapy.nixos-unified.home-manager.console.network = {
      enable = mkEnableOption "command-line network tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dogedns # dig alternative
      doggo
      gping # ping with data visualization
    ];
  };
}
