{ config, pkgs, ... }:

{
  services.tlp.enable = true;
  services.tlp.settings = {
    WIFI_PWR_ON_BAT = "off";
    USB_BLACKLIST_BTUSB = 1;
  };
} 
