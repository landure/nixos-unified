/**
  # Endor

  Endor is a main Laptop workstation.
*/
{ self, ... }:
let
  inherit (self.nixos-unified.lib) mkLinuxSystem;

  mainUser = "pierre-yves";
  stateVersion = "24.11";
in
{
  endor = mkLinuxSystem { home-manager = true; } {
    nixpkgs.hostPlatform = "x86_64-linux";
    imports = [
      self.nixosModules.default

      ./disko.nix

      # Your machine's configuration.nix goes here
      (
        { pkgs, ... }:
        {
          networking.hostName = "endor";
          nixos-unified.sshTarget = "pierre-yves@";

          boot.loader.grub.device = "nodev";
          fileSystems."/" = {
            device = "/dev/disk/by-label/nixos";
            fsType = "btrfs";
          };

          users.users.${mainUser}.isNormalUser = true;

          system.stateVersion = stateVersion;

          facter.reportPath = ./facter.json;
          disko.devices.disk.main.device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S3Z2NB0M434875N";

          biapy.nixos-unified.nixos = {
            presets.laptop.enable = true;
            hardware.openrgb.enable = true;
          };

          # Add Udev rules for ZSA keyboards
          hardware.keyboard.zsa.enable = true;
        }
      )

      # Setup home-manager in NixOS config
      {
        home-manager.users.${mainUser} = {
          imports = [ self.homeModules.default ];
          home.stateVersion = stateVersion;
        };
      }
    ];
  };
}
