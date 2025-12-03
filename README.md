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
