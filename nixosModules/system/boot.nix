/**
   # Boot configuration

   Configure Grub, Plymouth, and hibernation.

   GNU GRUB is a Multiboot boot loader.
   It was derived from GRUB, the GRand Unified Bootloader,
   which was originally designed and implemented by Erich Stefan Boleyn.

   - [Grub homepage](https://www.gnu.org/software/grub/).
   - [boot.loader.grub @ NixOS reference](https://search.nixos.org/options?query=boot.loader.grub).

  Memtest86+ is a stand-alone memory tester for x86 and x86-64 architecture
   computers.

   - [Memtest86+ homepage](https://memtest.org/)
     ([Memtest86+ @ GitHub](https://github.com/memtest86plus/memtest86plus/)).
   - [boot.loader.grub.memtest86 @ NixOS reference](https://search.nixos.org/options?query=boot.loader.grub.memtest86).
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

  cfg = config.biapy.nixos-unified.nixos.system.boot;
in
{
  options = {
    biapy.nixos-unified.nixos.system.boot = {
      enable = mkEnableOption "Nice Boot";
    };
  };

  config = mkIf cfg.enable {

    boot = {
      loader = {
        timeout = 3;

        grub = {
          enable = mkDefault true;
          # no need to set devices, disko will add all devices that have a EF02 partition to the list already
          # devices = [ ];
          efiSupport = mkDefault true;
          efiInstallAsRemovable = mkDefault true;

          memtest86 = {
            enable = mkDefault true;
            params = [
              # @see https://github.com/memtest86plus/memtest86plus/?tab=readme-ov-file#boot-options
              "dark" # change the default background colour from blue to black
              "screen.mode=1024x768" # (EFI framebuffer only) the preferred screen resolution
            ];
          };
        };
      };
      # Enable hibernation
      initrd.systemd.enable = mkDefault true;

      plymouth = {
        enable = mkDefault true;
        theme = mkDefault "nixos-bgrt";
        themePackages = mkDefault [ pkgs.nixos-bgrt-plymouth ];
      };
      kernelParams = [
        "quiet"
        "splash"

        # ZSwap
        "zswap.enabled=1"
        "zswap.zpool=zsmalloc"
        "zswap.compressor=zstd"
        "zswap.max_pool_percent=50"
      ];
    };
  };
}
