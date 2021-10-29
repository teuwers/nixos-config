{ config, pkgs, ... }:

{
  imports = 
  [ 
    ../home-manager/home.nix
  ];
  
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  hardware.pulseaudio.enable = false;
  
  networking.networkmanager.wifi.backend = "iwd";

} 
