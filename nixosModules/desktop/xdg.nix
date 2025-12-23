/**
  # XDG Desktop Integration

  The XDG Base Directory Specification defines where these files should be
  looked for by defining one or more base directories relative to which files
  should be located.

  ## XDG Desktop Portal

  Portal is frontend service for Flatpak and other desktop containment frameworks.

  `xdg-desktop-portal` exposes a series of D-Bus interfaces known as portals
  under a well-known name (`org.freedesktop.portal.Desktop`)
  and object path (`/org/freedesktop/portal/desktop`).

  Lists available `.desktop` files in `XDG_DATA_DIRS`:

  ```bash
  echo "${XDG_DATA_DIRS}" | tr ':' '\n' | xargs --replace fd '\.desktop$' '{}'
  ```

  ## 🛠️ Tech Stack

  - [XDG Base Directory Specification @ freedesktop.org](https://specifications.freedesktop.org/basedir-spec/latest/).
  - [XDG Desktop Portal homepage](https://flatpak.github.io/xdg-desktop-portal/)
    ([XDG Desktop Portal @ GitHub](https://github.com/flatpak/xdg-desktop-portal/)).

  ### 🧩 Portal Backends

  - [xdg-desktop-portal-gnome @ GNOME's GitLab](https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome).
  - [xdg-desktop-portal-gtk @ GitHub](https://github.com/flatpak/xdg-desktop-portal-gtk).
  - [xdg-desktop-portal-wlr @ GitHub](https://github.com/emersion/xdg-desktop-portal-wlr).

  ## 📝 Documentation

  - [xdg @ NixOS reference](https://search.nixos.org/options?query=xdg.).
  - [xdg.portal @ NixOS reference](https://search.nixos.org/options?channel=query=xdg.portal).

  ## 🙇 Acknowledgements

  - [XDG Base Directory Specification @ freedesktop.org](https://specifications.freedesktop.org/basedir-spec/latest/).
  - [xdg @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.enable).
  - [xdg.portal @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.portal.enable).
  - [systemd.user.sessionVariables @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-systemd.user.sessionVariables).
  - [home.sessionVariables @ Home Manager](https://nix-community.github.io/home-manager/options.xhtml#opt-home.sessionVariables).
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
  inherit (lib.lists) optional;

  cfg = config.biapy.nixos-unified.nixos.desktop.xdg;
in
{
  options = {
    biapy.nixos-unified.nixos.desktop.xdg = {
      enable = mkEnableOption "XDG Base Directory";
    };
  };

  config = mkIf cfg.enable {
    xdg = {
      portal = {
        enable = mkDefault true;

        # Sets environment variable NIXOS_XDG_OPEN_USE_PORTAL to 1
        # This will make xdg-open use the portal to open programs,
        # which resolves bugs involving programs opening inside FHS envs
        # or with unexpected env vars set from wrappers.
        xdgOpenUsePortal = mkDefault true;

        # Sets which portal backend should be used to provide the implementation
        # for the requested interface. For details check portals.conf(5).
        # These will be written with the name $desktop-portals.conf
        # for xdg.portal.config.$desktop and portals.conf for
        # xdg.portal.config.common as an exception.
        config = {
          common = {
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };

          gnome = {
            default = [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };

        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };
    };

    # Ensure that the portal definitions and Desktop Environment provided
    # configurations get linked.
    environment.pathsToLink = optional config.home-manager.useUserPackages [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };
}
