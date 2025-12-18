/**
  ## greetd

  greetd is a minimal login manager.

  - [Greetd @ NixOS Wiki](https://nixos.wiki/wiki/Greetd).

  ## tuigreet

  Graphical console greeter for greetd.

  - [tuigreet @ GitHub](https://github.com/apognu/tuigreet).
  - [Setting up greetd/tuigreet in NixOS with session detection and choosing (0.8.0 and 0.9.0) @ ~/ryjelsum](https://ryjelsum.me/homelab/greetd-session-choose/)
*/
{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) enum bool;
  inherit (lib.modules) mkIf mkDefault;
  inherit (lib.lists) optional;

  cfg = config.biapy.nixos-unified.nixos.xserver.displayManager;

  desktopSessions = config.services.displayManager.sessionData.desktops;
  inherit (pkgs.greetd) tuigreet;

  buildThemeOption =
    theme:
    lib.concatStrings (
      [ "'" ] ++ (lib.attrsets.mapAttrsToList (name: value: name + "=" + value + ";") theme) ++ [ "'" ]
    );
in
{
  options = {
    biapy.nixos-unified.nixos.xserver.displayManager = {
      enable = mkOption {
        type = bool;
        default = false;
        example = true;
        description = ''
          Whether to enable display manager.
        '';
      };

      type = mkOption {
        type = enum [
          "gdm"
          "tuigreet"
        ];
        default = "tuigreet";
        description = ''
          What display manager to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.xserver.displayManager.gdm.enable = mkDefault (cfg.type == "gdm");

    # Add tuigreet to the system
    environment.systemPackages = optional (cfg.type == "tuigreet") [ tuigreet ];

    # Configure greetd systemd service.
    services.greetd = mkIf (cfg.type == "tuigreet") {
      enable = mkDefault true;

      # Define greetd settings
      settings = rec {
        # Define tuigreet greetd session
        tuigreet_session =

          {
            command = mkDefault (
              lib.concatStringsSep " " [
                "${tuigreet}/bin/tuigreet"
                " --time" # display the current date and time
                " --remember" # remember last logged-in username
                " --remember-user-session" # remember last selected session for each user
                # @see https://ryjelsum.me/homelab/greetd-session-choose/
                " --sessions '${desktopSessions}/share/wayland-sessions'" # colon-separated list of Wayland session paths
                " --xsessions '${desktopSessions}/share/xsessions'" # colon-separated list of X11 session paths
                " --theme"
                (buildThemeOption {
                  border = "magenta";
                  text = "cyan";
                  prompt = "green";
                  time = "red";
                  action = "blue";
                  button = "yellow";
                  container = "black";
                  input = "red";
                })
              ]
            );
            # some tuigreet options are

            # --asterisks: display asterisks when a secret is typed
            # --theme THEME: define the application theme colors

            # Run with user greeter
            user = mkDefault "greeter";
          };

        # Set tuigreet_session as greetd default session
        default_session = mkDefault tuigreet_session;
      };
    };

  };
}
