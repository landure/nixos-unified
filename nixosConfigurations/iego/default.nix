{ self, ... }:
let
  mainUser = "pierre-yves";
  stateVersion = "24.11";
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
        # TODO: Put your /etc/nixos/hardware-configuration.nix here
        boot.loader.grub.device = "nodev";
        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "btrfs";
        };
        users.users.${mainUser}.isNormalUser = true;
        system.stateVersion = stateVersion;

        facter.reportPath = ./facter.json;
        disko.devices.disk.main.device = "/dev/sda";

        nixos-unified.sshTarget = "pierre-yves@192.168.178.37";
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
