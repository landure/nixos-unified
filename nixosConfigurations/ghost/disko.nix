/**
  # Disko single disk layout

  Iego use a small 20Go SSD.
*/
{ config, ... }:
{
  disko.devices.disk = {
    data = {
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          luks = {
            size = "100%";
            label = "luks-data";
            content = {
              type = "luks";
              name = "cryptdata";
              passwordFile = config.age.secrets.luks-encryption-key.path;
              settings = {
                allowDiscards = true;
                fallbackToPassword = true;
                # keyFile = config.age.secrets.luks-encryption-key.path;
              };
              extraOpenArgs = [
                "--allow-discards"
                "--perf-no_read_workqueue"
                "--perf-no_write_workqueue"
              ];
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "data"
                  "-f"
                ];
                subvolumes = {
                  "/data" = {
                    mountpoint = "/data";
                    mountOptions = [
                      "subvol=data"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };

    main = {
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          MBR = {
            priority = 0;
            size = "1M";
            type = "EF02";
          };
          ESP = {
            priority = 1;
            size = "4G";
            type = "EF00";
            label = "boot";
            name = "ESP";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            size = "100%";
            label = "luks";
            content = {
              type = "luks";
              name = "cryptroot";
              # disable settings.keyFile if you want to use interactive password entry
              passwordFile = config.age.secrets.luks-encryption-key.path;
              settings = {
                allowDiscards = true;
                fallbackToPassword = true;
                # keyFile = config.age.secrets.luks-encryption-key.path;
              };
              # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
              extraOpenArgs = [
                "--allow-discards"
                "--perf-no_read_workqueue"
                "--perf-no_write_workqueue"
              ];
              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "nixos"
                  "-f"
                ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "subvol=root"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "16G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
