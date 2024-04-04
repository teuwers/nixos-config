{ config, pkgs, ... }:

{
  services.desktopManager.plasma6 = {
    enable = true;
    notoPackage = pkgs.nerdfonts;
  };

  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
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
    kdePackages.kcmutils
    kdePackages.sddm-kcm
    kdePackages.kio
    kdePackages.kgpg
    kdePackages.kleopatra
    kdePackages.kdav
    kdePackages.kmail
    kdePackages.kcalc
    kdePackages.ktouch
    kdePackages.kontact
    kdePackages.skanpage
    kdePackages.kdenlive
    kdePackages.korganizer
    kdePackages.kio-extras
    kdePackages.plasma-disks
    kdePackages.plasma-vault
    kdePackages.kaddressbook
    kdePackages.print-manager
    smplayer
    config.nur.repos.baduhai.koi
  ];  
}
