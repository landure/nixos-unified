/**
  # Podman

  ## 🛠️ Tech Stack

  - [Podman homepage](https://podman.io/).
  - [Podman TUI](https://github.com/containers/podman-tui).
  - [LazyDocker](https://github.com/jesseduffield/lazydocker)
    is a Docker TUI.
  - [ctop homepage](https://ctop.sh/)
    ([ctop @ GitHub](https://github.com/bcicen/ctop))
    is a Docker monitoring TUI, showing running container resources usage.

  ## 📝 Documentation

  - [virtualisation.podman @ NixOS reference](https://search.nixos.org/options?query=virtualisation.podman).

  ## 🙇 Acknowledgements

  - [dtop homepage](https://dtop.dev/)
    ([dtop @ GitHub](https://github.com/amir20/dtop)).
  - [DockMate 🐳 @ GitHub](https://github.com/shubh-io/dockmate).
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
  inherit (pkgs) ctop lazydocker podman-tui;

  cfg = config.biapy.nixos-unified.nixos.server.podman;
in
{
  options = {
    biapy.nixos-unified.nixos.server.podman = {
      enable = mkEnableOption "Podman";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = mkDefault true;
      # Create an alias mapping podman to docker
      dockerCompat = mkDefault true;
      dockerSocket.enable = mkDefault true;
    };

    environment.defaultPackages = [
      ctop
      lazydocker
      podman-tui
    ];
  };
}
