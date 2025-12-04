{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs) nixos-rebuild home-manager;
  inherit (pkgs.stdenv.hostPlatform) system;

  rebuildCommand = lib.meta.getExe nixos-rebuild;

  hmCommand = lib.meta.getExe pkgs.home-manager;

  agenix = inputs.agenix.packages.${system}.default;
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
    agenix
    nixos-rebuild
    home-manager
  ];

  # https://devenv.sh/tasks/
  tasks = {
    "build:iego" = {
      description = "Apply changes to iego (ASUS eeePC)";
      exec = "${rebuildCommand} switch --target-host pierre-yves@192.168.178.37 --use-remote-sudo --flake .#iego";
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
        cmds = [ "${hmCommand} switch --flake '.#activate'" ];
        requires = {
          vars = [ "HOSTNAME" ];
        };
      };

      "utils:home-manager:news" = {
        aliases = [ "news" ];
        desc = "Read home-manager news";
        cmds = [ "${hmCommand} news --flake '.#{{.HOSTNAME}}'" ];
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
