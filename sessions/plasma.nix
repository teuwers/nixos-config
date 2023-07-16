{ config, pkgs, ... }:

{
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.phononBackend = "gstreamer";
  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.enable = true;
  
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    libsForQt5.kate
    libsForQt5.konsole
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    darkman
    libsForQt5.kdialog
    libsForQt5.plasma-integration
    libsForQt5.plasma-browser-integration
  ];  
}
