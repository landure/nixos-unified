# NixOS Unified configuration

To install a new remote host:

```bash
nix run github:nix-community/nixos-anywhere -- \
    --flake .#<hostname> --target-host nixos@<remote-host-ip>
```

<!-- CSpell:ignore nixos -->

To update the remote host:

```bash
nix run .#activate '<hostname>'
```

Or:

```bash
task 'build:<hostname>'
task '<hostname>'
```

To update the local host:

```bash
nix run .#activate
```

To list available tasks:

```bash
task
```

## Thanks

### Disko & NixOS Anywhere

- [Nixos encrypted installation with kexec, disko, luks, btrfs and remote luks
  unblock on a Hetzner auction server (or any cloud provider vps/vds)
  @ Life is too short to be someone else](https://www.brokenpip3.com/posts/2025-05-25-nixos-secure-installation-hetzner/).
- [How I Set up BTRFS and LUKS on NixOS Using Disko @ Haseeb Majid](https://haseebmajid.dev/posts/2024-07-30-how-i-setup-btrfs-and-luks-on-nixos-using-disko/).

<!-- CSpell:ignore kexec disko luks btrfs Haseeb Majid -->
