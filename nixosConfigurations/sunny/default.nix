{ self, ... }:
let
  mainUser = "pierre-yves";
  stateVersion = "25.05";
in
self.nixos-unified.lib.mkLinuxSystem { home-manager = true; } {
  nixpkgs.hostPlatform = "x86_64-linux";
  imports = [
    self.nixosModules.default

    ./disko.nix

    # Your machine's configuration.nix goes here
    (
      { pkgs, ... }:
      {
        networking.hostName = "sunny";
        nixos-unified.sshTarget = "nixos@192.168.178.4";

        # TODO: Put your /etc/nixos/hardware-configuration.nix here
        boot.loader.grub.device = "nodev";

        # fileSystems."/" = { device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S3Z2NB0M434899Y"; fsType = "btrfs"; };
        users.users.${mainUser}.isNormalUser = true;
        system.stateVersion = stateVersion;

        facter.reportPath = ./facter.json;
        disko.devices.disk.main.device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S3Z2NB0M434899Y";
        disko.devices.disk.data.device = "/dev/disk/by-id/ata-TOSHIBA_DT01ACA300_Z4O2RH7GS";
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
}
