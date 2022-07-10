{ config, pkgs, ... }:

{
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.enable = true;

  #networking.networkmanager.wifi.backend = "iwd";

  environment.systemPackages = with pkgs; [
    libsForQt5.kate
    libsForQt5.konsole
  ];  
}
