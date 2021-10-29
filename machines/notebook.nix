{ config, pkgs, ... }:

{
  imports =
    [ 
	# Choose WM/DE
      ../sessions/sway/sway.nix
	  ../sessions/sway/sway-notebook.nix
      #../sessions/gnome.nix
    ];

  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  services.xserver.useGlamor = true;
  
#### Bootloader
    
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
	timeout = 30;
  };
  
#### Network

  networking = {
    hostName = "mike-notebook";
    interfaces.enp1s0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    wireless.iwd.enable = true;
    };
  
#  networking.networkmanager = {
#    enable = true;
#    dns = "systemd-resolved";
#    wifi = {
#      backend = "iwd";
#      powersave = true;
#    };
#  };  
# users.users.tyd2l.extraGroups = [ "networkmanager" ];
}