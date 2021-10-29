# nixos-dotfiles
My dotfiles for NixOS setup

## Installation

### Partitioning
I have 2 drives on my system: NVME SSD and a regular SATA drive. I will use NVME SSD as /, swap and SATA drive as separate home.
```
```sh
## Generate keys for single password unlock
$ dd if=/dev/urandom of=./keyfile-root.bin bs=1024 count=4
$ dd if=/dev/urandom of=./keyfile-swap.bin bs=1024 count=4
$ dd if=/dev/urandom of=./keyfile-home.bin bs=1024 count=4
```
### Setup LUKS and add the keys
```sh
# Enter the passphrase which is used to unlock disk. You will enter this in grub on every boot
$ cryptsetup luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 /dev/nvme0n1p2

# Add a second key which will be used by nixos. You will need to enter the pasphrase from previous step
$ cryptsetup luksAddKey /dev/nvme0n1p2 keyfile-root.bin
$ cryptsetup luksOpen /dev/nvme0n1p2 crypted-nixos -d keyfile-root.bin

# For swap just the second random generated key
$ cryptsetup luksFormat -c aes-xts-plain64 -s 256 -h sha512 /dev/nvme0n1p3 -d keyfile-swap.bin
$ cryptsetup luksOpen /dev/nvme0n1p3 crypted-swap -d keyfile-swap.bin

# The next key for /home
$ cryptsetup luksFormat -c aes-xts-plain64 -s 256 -h sha512 /dev/sda1 -d keyfile-home.bin
$ cryptsetup luksOpen /dev/sda1 crypted-home -d keyfile-home.bin
```
### Format the partitions and mount
```sh
$ mkfs.fat -F 32 /dev/nvme0n1p1
$ mkfs.ext4 -L root /dev/mapper/crypted-nixos
$ mkswap -L swap /dev/mapper/crypted-swap
$ mkfs.ext4 -L home /dev/mapper/crypted-home
```

```sh
$ mount /dev/mapper/crypted-nixos /mnt
$ mkdir -p /mnt/{boot/efi,home,git}
$ mount /dev/nvme0n1p1 /mnt/boot/efi
$ mount /dev/mapper/crypted-home /mnt/home
$ swapon /dev/mapper/crypted-swap
```
### Copy the keys
```sh
$ mkdir -p /mnt/etc/secrets/initrd/
$ cp keyfile-root.bin keyfile-swap.bin keyfile-home.bin /mnt/etc/secrets/initrd
$ chmod 000 /mnt/etc/secrets/initrd/keyfile*.bin
```
### Generate and edit configuration
```sh
$ nixos-generate-config --root /mnt
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
      # Create /mnt/etc/secrets/initrd directory and copy keys to it
      "keyfile-root.bin" = "/etc/secrets/initrd/keyfile-root.bin";
      "keyfile-swap.bin" = "/etc/secrets/initrd/keyfile-swap.bin";
      "keyfile-home.bin" = "/etc/secrets/initrd/keyfile-home.bin";
    };
};
```

You can get the UUIDs by running
```sh
$ blkid
```
Install NixOS and reboot
```sh
$ nix-channel --add https://nixos.org/channels/nixos-unstable nixos
$ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nixos-install
$ reboot
```
