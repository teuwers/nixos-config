{ config, pkgs, ... }:

{
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  
  programs.kdeconnect.enable = true;
  programs.firefox.preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.konsole
    kdePackages.qtstyleplugin-kvantum
    kdePackages.kdialog
    kdePackages.plasma-integration
    kdePackages.plasma-browser-integration
    kdePackages.ktorrent
    nur.repos.baduhai.koi
  ];  
}
