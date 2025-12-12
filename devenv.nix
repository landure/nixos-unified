{ lib, pkgs, ... }:
let
  inherit (lib.meta) getExe;
  inherit (pkgs)
    nixos-rebuild-ng
    nixos-anywhere
    home-manager
    sops
    ssh-to-age
    ;
  # inherit (pkgs.stdenv.hostPlatform) system;

  rebuildExe = getExe nixos-rebuild-ng;
  anywhereExe = getExe nixos-anywhere;

  hmExe = getExe home-manager;
  sopsExe = getExe sops;
in
{
  biapy.go-task.enable = true;
  biapy-recipes = {
    git.enable = true;
    nix.enable = true;
    markdown.enable = true;
    shell.enable = true;
    security.enable = true;
    secrets.gitleaks.enable = true;
  };

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    commitizen.enable = true;
    # shellcheck.enable = true;
  };

  packages = [
    sops
    ssh-to-age
    nixos-rebuild-ng
    home-manager
    nixos-anywhere
  ];

  # https://devenv.sh/tasks/
  tasks = {
    "build:iego" = {
      description = "Apply changes to iego (ASUS eeePC)";
      exec = "${rebuildExe} switch --target-host pierre-yves@192.168.178.37 --use-remote-sudo --flake .#iego";
    };
  };

  scripts = {
    "deploy-nixos" = {
      description = ''
        Run nixos-anywhere with SOPS luks password file copy
        See <https://github.com/nix-community/disko/issues/641#issuecomment-2142627125>
        and <https://nix-community.github.io/nixos-anywhere/howtos/secrets.html#example-decrypting-an-openssh-host-key-with-pass>
      '';
      exec = ''
        set -e

        clear_luks_passwordfile="$(mktemp --quiet)"
        extra_files="$(mktemp --quiet --directory)"
        mkdir --mode=755 --parent "''${extra_files}/etc/ssh"

        cleanup() {
          echo "Removing decrypted SOPS secrets"
          [[ -e "''${clear_luks_passwordfile}" ]] && rm "''${clear_luks_passwordfile}" || true
          [[ -e "''${extra_files}" ]] && rm --recursive "''${extra_files}" || true
        }

        trap 'cleanup' EXIT

        hostname="''${1}"
        target_host="''${2}"

        secret_file="''${DEVENV_ROOT}/secrets/hosts/''${hostname}.yaml"

        # SOPS_AGE_SSH_PRIVATE_KEY_FILE="''${HOME}/.ssh/id_ed25519"

        ${sopsExe} --enable-local-keyservice --decrypt --extract "['luks_password']" \
            "''${secret_file}" > "''${clear_luks_passwordfile}"
        # See https://github.com/nix-community/nixos-anywhere/issues/604#issuecomment-3642062243
        ${sopsExe} --enable-local-keyservice --decrypt --extract "['openssh']['private_key']" \
            "''${secret_file}" > "''${extra_files}/etc/ssh/ssh_host_ed25519_key"
        ${sopsExe} --enable-local-keyservice --decrypt --extract "['openssh']['public_key']" \
            "''${secret_file}" > "''${extra_files}/etc/ssh/ssh_host_ed25519_key.pub"

        chmod 600 "''${extra_files}/etc/ssh/ssh_host_ed25519_key"

        ${anywhereExe} \
          --disk-encryption-keys '/tmp/luks_passwordfile' "''${clear_luks_passwordfile}" \
          --extra-files "''${extra_files}" \
          --flake ".#''${hostname}" \
          --target-host "''${target_host}"

      '';
    };
  };

  biapy.go-task.taskfile = {
    vars = {
      HOSTNAME = {
        sh = "hostname";
      };
    };

    tasks = {
      "build:home-manager" = {
        aliases = [
          "home"
          "switch"
        ];
        desc = "🔨 Apply changes to home-manager configuration";
        cmds = [ "${hmExe} switch --flake '.#activate'" ];
        requires = {
          vars = [ "HOSTNAME" ];
        };
      };

      "utils:home-manager:news" = {
        aliases = [ "news" ];
        desc = "Read home-manager news";
        cmds = [ "${hmExe} news --flake '.#{{.HOSTNAME}}'" ];
        requires = {
          vars = [ "HOSTNAME" ];
        };
      };

      "build:sunny" = {
        aliases = [ "sunny" ];
        desc = "🔨 Apply changes to sunny (Home server)";
        cmds = [ "nix run .#activate sunny" ];
      };

      "build:iego" = {
        aliases = [ "iego" ];
        desc = "🔨 Apply changes to iego (ASUS eeePC)";
        cmds = [ "nix run .#activate iego" ];
      };

      "build:ghost" = {
        aliases = [ "ghost" ];
        desc = "🔨 Apply changes to ghost (co-bre-pc04 VM)";
        cmds = [ "nix run .#activate ghost" ];
      };
    };
  };

  # See full reference at https://devenv.sh/reference/options/
}
