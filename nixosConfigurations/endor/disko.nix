/**
  # Disko single disk layout
*/
_: {
  disko.devices.disk.main = {
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
            passwordFile = "/tmp/luks_passwordfile";
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
                "/var" = {
                  mountpoint = "/var";
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

}
