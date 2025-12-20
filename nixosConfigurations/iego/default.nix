/**
  # Iego

  Iego is an old ASUS eeePC, lightweight TUI for on the move writing.
*/
{ self, ... }:
let
  inherit (self.nixos-unified.lib) mkLinuxSystem;

  mainUser = "pierre-yves";
  stateVersion = "24.11";
in
{
  iego = mkLinuxSystem { home-manager = true; } {
    nixpkgs.hostPlatform = "x86_64-linux";
    imports = [
      self.nixosModules.default

      ./disko.nix
      # Your machine's configuration.nix goes here
      (
        { pkgs, ... }:
        {
          networking.hostName = "iego";
          nixos-unified.sshTarget = "pierre-yves@192.168.178.37";

          boot.loader.grub.device = "nodev";
          fileSystems."/" = {
            device = "/dev/disk/by-label/nixos";
            fsType = "btrfs";
          };
          users.users.${mainUser}.isNormalUser = true;
          system.stateVersion = stateVersion;

          facter.reportPath = ./facter.json;
          disko.devices.disk.main.device = "/dev/sda";

          biapy.nixos-unified.nixos = {
            presets.laptop.enable = true;
          };
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
