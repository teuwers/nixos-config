# nixos-dotfiles
My dotfiles for NixOS setup

# Installation

### Partitioning
I have FDE on my notebook, but don't have on my desktop.
```sh
# sudo su
## Generate keys for single password unlock
# dd if=/dev/urandom of=./keyfile-root.bin bs=1024 count=4
# dd if=/dev/urandom of=./keyfile-swap.bin bs=1024 count=4
```
### Setup LUKS and add the keys

```sh
# Enter the passphrase which is used to unlock disk. You will enter this in grub on every boot
# cryptsetup luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 /dev/nvme0n1p2

# Add a second key which will be used by nixos. You will need to enter the pasphrase from previous step
# cryptsetup luksAddKey /dev/nvme0n1p2 keyfile-root.bin
# cryptsetup luksOpen /dev/nvme0n1p2 crypted-nixos -d keyfile-root.bin

# For swap just the second random generated key
# cryptsetup luksFormat -c aes-xts-plain64 -s 256 -h sha512 /dev/nvme0n1p3 -d keyfile-swap.bin
# cryptsetup luksOpen /dev/nvme0n1p3 crypted-swap -d keyfile-swap.bin
```

### Format the partitions and mount
```sh
# mkfs.fat -F 32 /dev/nvme0n1p1
# mkfs.ext4 -L root /dev/mapper/crypted-nixos
# mkswap -L swap /dev/mapper/crypted-swap
```

```sh
# mount /dev/mapper/crypted-nixos /mnt
# mkdir -p /mnt/boot/efi
# mount /dev/nvme0n1p1 /mnt/boot/efi
# swapon /dev/mapper/crypted-swap
```

### Copy the keys
```sh
# mkdir -p /mnt/etc/secrets/initrd/
# cp keyfile-root.bin keyfile-swap.bin /mnt/etc/secrets/initrd
# chmod 000 /mnt/etc/secrets/initrd/keyfile*.bin
```

### Generate and edit configuration
```sh
# nixos-generate-config --root /mnt
```
Add the following to `/etc/nixos/hardware-configuration.nix`

```nix
  boot.initrd = {
    luks.devices."crypted-nixos" = {
      device = "/dev/disk/by-uuid/..."; # UUID for /dev/nvme01np2 
      keyFile = "/keyfile-root.bin";
      allowDiscards = true;
    };
    luks.devices."crypted-swap" = {
      device = "/dev/disk/by-uuid/..."; # UUID for /dev/nvme01np3 
      keyFile = "/keyfile-swap.bin";
      allowDiscards = true;
    };
    luks.devices."crypted-home" = {
      device = "/dev/disk/by-uuid/..."; # UUID for /dev/sda1 
      keyFile = "/keyfile-home.bin";
      allowDiscards = true;
    };
    secrets = {
      "keyfile-root.bin" = "/etc/secrets/initrd/keyfile-root.bin";
      "keyfile-swap.bin" = "/etc/secrets/initrd/keyfile-swap.bin";
    };
};
```

You can get the UUIDs by running
```sh
# blkid
```
### Select machine
Create ```/mnt/etc/nixos/machines/current.nix``` with:
```nix
{ config, pkgs, ... }:

{
  imports =
    [ 
	 #./desktop.nix #uncomment for desktop setup
	 #./notebook.nix #uncomment for laptop setup
    ];
}
```
### Install NixOS and reboot
```sh
# nix-channel --add https://nixos.org/channels/nixos-unstable nixos
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update
# nixos-install
# reboot
```
