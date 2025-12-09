/**
  # sudo

  Sudo (su “do”) allows a system administrator to delegate authority to give
  certain users (or groups of users) the ability to run some (or all) commands
  as root or another user while providing an audit trail of the commands
  and their arguments.

  - [sudo homepage](https://www.sudo.ws/)
    ([sudo @ GitHub](https://github.com/sudo-project/sudo)).
  - [security.sudo @ NixOS reference](https://search.nixos.org/options?query=security.sudo)
  - [nix.settings.extra-trusted-users @ NixOS reference](https://search.nixos.org/options?query=nix.settings.extra-trusted-users)
*/
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.console.sudo;

in
{
  options = {
    biapy.nixos-unified.nixos.console.sudo.enable = mkOption {
      type = bool;
      default = true;
      example = true;
      description = ''
        Whether to add default sudo configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Enable sudo for users in wheel group, and allow sudoers reboot and poweroff
    # @see https://nixos.wiki/wiki/Sudo
    security.sudo = {
      enable = mkDefault true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl suspend";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = [ "NOPASSWD" ];
            }

            # Allow passwordless use of nixos-rebuild switch --use-remote-sudo --target-host "user@host"
            {
              command = "${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --set /nix/store/*nixos-system*";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
    };

    # Allow sudoers to run nix commands without password and apply remote builds
    nix.settings.extra-trusted-users = [ "@wheel" ];
  };
}
