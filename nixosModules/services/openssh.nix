/**
  # OpenSSH

  - [OpenSSH homepage](https://www.openssh.org/).
  - [fail2ban @ GitHub](https://github.com/fail2ban/fail2ban ).
  - [SSH @ Official NixOS Wiki](https://wiki.nixos.org/wiki/SSH).
  - [services.openssh reference](https://search.nixos.org/options?show=services.openssh).
  - [environment.etc reference](https://search.nixos.org/options?show=environment.etc).
  - [users.groups reference](https://search.nixos.org/options?show=users.groups).
*/
{ config, lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types)
    bool
    path
    nullOr
    submodule
    ;
  inherit (lib.modules) mkIf mkDefault;

  cfg = config.biapy.nixos-unified.nixos.services.openssh;

in
{
  options = {
    biapy.nixos-unified.nixos.services.openssh = {
      enable = mkOption {
        type = bool;
        default = true;
        example = true;
        description = ''
          Whether to enable OpenSSH server, with fail2ban.
        '';
      };

      ed25519_key = mkOption {
        type = nullOr (submodule {
          options = {
            private_key = mkOption {
              type = path;
              description = ''
                Content of the ED25519 private key to install in /etc/ssh/ssh_host_ed25519_key.
              '';
            };
            public_key = mkOption {
              type = path;
              description = ''
                Content of the ED25519 public key to install in /etc/ssh/ssh_host_ed25519_key.pub.
              '';
            };
          };
        });
        default = null;
        description = ''
          Optional ED25519 host key configuration. When set, installs the private and public keys to /etc/ssh.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    users.groups.ssh-users = { };

    # sops.secrets = {
    #   "openssh/private_key" = {
    #     mode = "0600";
    #     owner = config.users.users.root.name;
    #     inherit (config.users.users.root) group;
    #     # path = "/etc/ssh/ssh_host_ed25519_key"
    #   };
    #   "openssh/public_key" = {
    #     mode = "0644";
    #     owner = config.users.users.root.name;
    #     inherit (config.users.users.root) group;
    #     # path = "/etc/ssh/ssh_host_ed25519_key.pub"
    #   };
    # };

    # systemd.services.sshd-keygen.after = [ "sops-nix.service" ];

    # environment.etc = mkIf (cfg.ed25519_key != null) {
    #   "ssh/ssh_host_ed25519_key" = {
    #     source = config.sops.secrets."openssh/private_key".path;
    #     mode = "0600";
    #     uid = 0;
    #     gid = 0;
    #   };
    #   "ssh/ssh_host_ed25519_key.pub" = {
    #     source = config.sops.secrets."openssh/public_key".path;
    #     mode = "0644";
    #     uid = 0;
    #     gid = 0;
    #   };
    # };

    services = {
      # userborn.enable = true;
      openssh = {
        enable = mkDefault true;

        settings = mkDefault {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          AllowGroups = [ "ssh-users" ];
        };

        hostKeys = [
          {
            comment = "ghost";
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];

      };
      fail2ban.enable = mkDefault true;
    };

  };
}
