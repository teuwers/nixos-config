{ config, pkgs, ... }:

{
  services.desktopManager.plasma6 = {
    enable = true;
    notoPackage = pkgs.nerdfonts;
  };

  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  
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
    config.nur.repos.baduhai.koi
  ];  
}
