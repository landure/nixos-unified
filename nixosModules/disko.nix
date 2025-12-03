/**
  # Disko configuration,

  ## Thanks

  - [disko - Declarative disk partitioning documentation](https://github.com/nix-community/disko/blob/master/docs/INDEX.md).
  - [cryptsetup @ GitLab](https://gitlab.com/cryptsetup/cryptsetup).
  - [dm-crypt documentation](https://gitlab.com/cryptsetup/cryptsetup/-/wikis/DMCrypt).
  - [EP 68: Frameworks, Filesystems and Fixes @ Linux Matters](https://linuxmatters.sh/68/).
*/
{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types)
    listOf
    str
    attrsOf
    anything
    ;

  # cfg = config.biapy.nixos-unified.nixos.disko;

in
{

  options = {
    biapy.nixos-unified.nixos.disko = {
      luks = {
        settings = mkOption {
          type = attrsOf anything;
          description = ''
            disko's LUKS default settings.

            See [boot.initrd.luks.devices.<name> @ NixOS search](https://search.nixos.org/options?query=boot.initrd.luks.devices.%3Cname%3E).
          '';
          default = {
            keyFile = "/tmp/secret.key";
            keyFileSize = 2048;
            keyFileOffset = 1024;

            allowDiscards = true;
            fallbackToPassword = true;
          };
        };
        extraFormatArgs = mkOption {
          type = listOf str;
          description = ''
            Extra arguments to pass to `cryptsetup luksFormat` when formatting

            common LUKS configuration, for encryption.

            see: [cryptsetup-luksFormat(8) — Linux manual page](https://www.man7.org/linux/man-pages/man8/cryptsetup-luksFormat.8.html).
          '';
          default = [ "--pbkdf argon2id" ];
        };
        extraOpenArgs = mkOption {
          type = listOf str;
          description = ''
            Extra arguments to pass to `cryptsetup luksOpen` when opening.

            common LUKS configuration, for encryption.

            See: [cryptsetup-open(8) — Linux manual page](https://www.man7.org/linux/man-pages/man8/cryptsetup-open.8.html).
          '';
          default = [
            # "--allow-discards"
            # "--perf-no_read_workqueue"
            # "--perf-no_write_workqueue"
            "--cipher=aes-xts-plain64"
            "--hash=sha256"
            "--key-size=256"
            "--iter-time=1000"
            "--pbkdf-memory=1048576"
            "--sector-size=4096"
          ];
        };
      };
      btrfs.mountOptions = mkOption {
        type = listOf str;
        description = ''
          common btrfs mount options.
        '';
        default = [
          "compress=lzo"
          "discard=async"
          "noatime"
          "rw"
          "space_cache=v2"
          "ssd"
        ];
      };
    };
  };
}
