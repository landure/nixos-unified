/**
  # co-bre-p0101

  NixOS WSL on Windows 11 laptop.
*/
{ self, ... }:
let
  inherit (self.nixos-unified.lib) mkLinuxSystem;

  mainUser = "pierre-yves";
  stateVersion = "24.11";
in
{
  co-bre-p0101 = mkLinuxSystem { home-manager = true; } {
    nixpkgs.hostPlatform = "x86_64-linux";
    imports = [
      self.nixosModules.default
      self.nixos-wsl.nixosModules.default

      # Your machine's configuration.nix goes here
      (
        { pkgs, ... }:
        {
          networking.hostName = "co-bre-p0101";
          nixos-unified.sshTarget = "${mainUser}@192.168.2.165";

          users.users.${mainUser}.isNormalUser = true;

          system.stateVersion = stateVersion;

          facter.reportPath = ./facter.json;

          wsl.enable = true;
          wsl.defaultUser = mainUser;
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
