# NixOS configuration example

This repository contains a NixOS configuration and reusable modules. The tracked `private.nix` contains example identity values only. Review each enabled service and filesystem declaration before adapting the configuration to another host.

## Layout

- `configuration.nix` is the entry point. `modules/default.nix` imports the regular `.nix` files in `modules/`.
- `modules/` contains service and system settings.
- `pkgs/` contains system and user package lists plus a custom package definition.
- `private.nix` supplies public example values, including the username `example`, and loads ignored `private.local.nix` when present.
- `hardware.example.nix` is a reference module with placeholder root, boot, data-disk, tmpfs, and mergerfs mounts. It is used when ignored `hardware.nix` is absent.

This repository is not a flake and does not include Home Manager configuration.

## Prepare a local configuration

1. Create an ignored `private.local.nix` containing an attribute set with the real values you need to override. At minimum, set the account name, host name, unique ZFS host ID, domain, Caddy contact email, and any SSH public keys and Caddy virtual hosts used by the machine. Any value left unchanged in `private.nix` is an example placeholder.
2. Put the target machine's generated hardware configuration in ignored `hardware.nix`. It takes precedence over `hardware.example.nix`. Review its filesystems, boot settings, and architecture on that machine.
3. Review service modules for required runtime files, external commands, open ports, and local backends.
4. On the target NixOS host, inspect the result with `sudo nixos-rebuild dry-build -I nixos-config=./configuration.nix`. After reviewing it, use `sudo nixos-rebuild test -I nixos-config=./configuration.nix` when appropriate.

The example hardware file has placeholder disk identifiers and is for reading or adaptation. A fresh clone is not expected to build or boot as-is. Do not deploy with example identity or hardware values.

## Secrets

No secret manager is configured here. Keep credentials and private keys out of tracked Nix files. Services that need credentials should read them from runtime files or an approved secret-management system.
