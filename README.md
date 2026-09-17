# NixOS

## Install

Boot the NixOS minimal ISO and run:

```bash
# Confirm disks match disko.nix
lsblk

# Partition + LUKS + btrfs + mount (same passphrase at both prompts)
sudo nix --experimental-features 'nix-command flakes' run \
    github:nix-community/disko/latest -- \
    --mode disko \
    --flake github:willmccallion/nixos#nix

# Install (prompts for root password)
sudo nixos-install --flake github:willmccallion/nixos#nix

reboot
```

## Post-Install

After first boot, open a terminal and run:

```bash
# Replace initial password
passwd

# Clone config to expected path
git clone --recurse-submodules https://github.com/willmccallion/nixos.git ~/.nixos
```

## Updating

```bash
nix-update   # nh os switch --update
nix-gc       # nh clean all
```
