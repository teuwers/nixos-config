#!/usr/bin/env bash

sudo su
sudo chown -R teuwers /etc/nixos
exit

mkdir -p ~/.repos
ln -s /etc/nixos ~/.repos/nixos-config
echo "file:///home/teuwers/.repos Repos" >> ~/.config/gtk-3.0/bookmarks

mkdir -p ~/.yandex-disk
echo "file:///home/teuwers/.yandex-disk Yandex.Disk" >> ~/.config/gtk-3.0/bookmarks
echo "Name Yandex.Disk folder .yandex-disk"
yandex-disk setup
