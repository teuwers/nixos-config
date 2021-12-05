{ config, pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.enable = true;
  
  hardware.pulseaudio.enable = false;
  
  networking.networkmanager.wifi.backend = "iwd";
  
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.gnome-shell-extensions
    gnomeExtensions.tilingnome
    gnomeExtensions.tray-icons-reloaded
  ];

} 
