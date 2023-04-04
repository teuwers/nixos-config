#!/usr/bin/env bash

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

umount -Rq /mnt
swapoff
cryptsetup -q luksClose crypted-nixos
cryptsetup -q luksClose crypted-swap

dd if=/dev/urandom of=./keyfile-root.bin bs=1024 count=4
dd if=/dev/urandom of=./keyfile-swap.bin bs=1024 count=4

# Partitioning
parted -s /dev/sda mklabel gpt
parted -s /dev/sda mkpart fat32 1M 500M
parted -s /dev/sda set 1 esp on

parted -s /dev/sda mkpart primary 500M 20.5G
parted -s /dev/sda mkpart primary 20.5G 100%

mkfs.fat -F 32 /dev/sda1

echo "Type passphrase for LUKS: "
while IFS = read -p "$PASS_VAR" -r -s -n 1 LETTER
do
    # if you press enter then the condition 
    # is true and it exit the loop
    if [[ $LETTER == $'\0' ]]
    then
        break
    fi
    
    # the letter will store in password variable
    LUKS_PASS=LUKS_PASS+"$LETTER"
    
    # in place of password the asterisk (*) 
    # will printed
    PASS_VAR="*"
done

echo $LUKS_PASS | cryptsetup -q luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 /dev/sda3 -d -
echo $LUKS_PASS | cryptsetup -q luksAddKey /dev/sda3 keyfile-root.bin -d -
cryptsetup -q luksOpen /dev/sda3 crypted-nixos -d keyfile-root.bin 

cryptsetup -q luksFormat -c aes-xts-plain64 -s 256 -h sha512 /dev/sda2 -d keyfile-swap.bin
cryptsetup -q luksOpen /dev/sda2 crypted-swap -d keyfile-swap.bin

mkfs.ext4 -L root /dev/mapper/crypted-nixos
mkswap -L swap /dev/mapper/crypted-swap
mount /dev/mapper/crypted-nixos /mnt
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
swapon /dev/mapper/crypted-swap

mkdir -p /mnt/etc/secrets/initrd/
mv -t /mnt/etc/secrets/initrd/ keyfile-root.bin keyfile-swap.bin
chmod 000 /mnt/etc/secrets/initrd/keyfile*.bin

nixos-generate-config --root /mnt
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/
rm -r /mnt/etc/nixos
git clone --recurse-submodules https://github.com/teuwers/nixos-config.git /mnt/etc/nixos
mv /mnt/etc/hardware-configuration.nix /mnt/etc/nixos/
echo '{ config, pkgs, ... }:

{
  imports =
    [ 
	 ./notebook.nix
    ];
}' >> /mnt/etc/nixos/machines/current.nix

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

SDA2_UUID=$(blkid -s UUID -o value /dev/sda2)
SDA3_UUID=$(blkid -s UUID -o value /dev/sda3)
sed -i "s/crypted-nixos/'
  boot.initrd = {
    luks.devices."crypted-nixos" = { 
      device = "/dev/disk/by-uuid/'$SDA3_UUID'";
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
  };' /mnt/etc/nixos/hardware-configuration.nix

nixos-install

echo "Workaround for /etc bug:
sudo nixos-enter
nixos-install --root /"
