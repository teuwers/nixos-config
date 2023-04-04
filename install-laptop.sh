#!/usr/bin/env bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

umount -R /mnt

dd if=/dev/urandom of=./keyfile-root.bin bs=1024 count=4
dd if=/dev/urandom of=./keyfile-swap.bin bs=1024 count=4

# Partitioning
parted /dev/sda mklabel gpt
parted /dev/sda mkpart fat32 1M 500M
parted /dev/sda set 1 esp on

parted /dev/sda mkpart primary 500M 20.5G
parted /dev/sda mkpart primary 20.5G 100%

mkfs.fat -F 32 /dev/sda1

cryptsetup luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 /dev/sda3
cryptsetup luksAddKey /dev/sda3 keyfile-root.bin
cryptsetup luksOpen /dev/sda3 crypted-nixos -d keyfile-root.bin

cryptsetup luksFormat -c aes-xts-plain64 -s 256 -h sha512 /dev/sda2 -d keyfile-swap.bin
cryptsetup luksOpen /dev/sda2 crypted-swap -d keyfile-swap.bin

mkfs.ext4 -L root /dev/mapper/crypted-nixos
mkswap -L swap /dev/mapper/crypted-swap
mount /dev/mapper/crypted-nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
swapon /dev/mapper/crypted-swap

mkdir -p /mnt/etc/secrets/initrd/
cp keyfile-root.bin keyfile-swap.bin /mnt/etc/secrets/initrd
chmod 000 /mnt/etc/secrets/initrd/keyfile*.bin

nixos-generate-config --root /mnt
mv /mnt/etc/nixos/hardware-configuration.nix ~/
rm -r /mnt/etc/nixos
cp -r /home/nixos/nixos-config /mnt/etc/nixos
mv ~/hardware-configuration.nix /mnt/etc/nixos/
echo '{ config, pkgs, ... }:

{
  imports =
    [ 
	 ./notebook.nix
    ];
}' >> /mnt/etc/nixos/machines/current.nix

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

truncate -s -1 /mnt/etc/nixos/hardware-configuration.nix
SDA2_UUID=$(blkid -s UUID -o value /dev/sda2)
echo '  
  boot.initrd = {
    luks.devices."crypted-nixos" = { 
      keyFile = "/keyfile-root.bin";
      allowDiscards = true;
    };
    luks.devices."crypted-swap" = {
      device = "/dev/disk/by-uuid/'$SDA2_UUID'";
      keyFile = "/keyfile-swap.bin";
      allowDiscards = true;
    };
    secrets = {
      "keyfile-root.bin" = "/etc/secrets/initrd/keyfile-root.bin";
      "keyfile-swap.bin" = "/etc/secrets/initrd/keyfile-swap.bin";
    };
  };
}' >> /mnt/etc/nixos/hardware-configuration.nix

nixos-install

echo "Workaround for /etc bug:
sudo nixos-enter
nixos-install --root /"

