{ lib, pkgs, ... }:
let
  inherit (lib.meta) getExe;
  inherit (pkgs) nixos-rebuild home-manager sops;
  # inherit (pkgs.stdenv.hostPlatform) system;

  rebuildExe = getExe nixos-rebuild;

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
    nixos-rebuild
    home-manager
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
      '';
      exec = ''
        set -e

        hostname="''${1}"
        target_host="''${2}"

        secret_file="''${DEVENV_ROOT}/secrets/hosts/''${hostname}.yaml"

        clear_luks_passwordfile="$(mktemp --quiet)"

        SOPS_AGE_SSH_PRIVATE_KEY_FILE="''${HOME}/.ssh/id_ed25519" \
          ${sopsExe} --decrypt --extract "['luks_password']" \
            "''${secret_file}" > "''${clear_luks_passwordfile}"

          cat "''${clear_luks_passwordfile}"

        nix run 'github:nix-community/nixos-anywhere' -- \
          --disk-encryption-keys '/tmp/luks_passwordfile' "''${clear_luks_passwordfile}" \
          --flake ".#''${hostname}" --target-host "''${target_host}"

        rm "''${clear_luks_passwordfile}"
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
