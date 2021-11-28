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

  boot.loader = {
    timeout = 30;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      device = "nodev";
      version = 2;
      efiSupport = true;
      enableCryptodisk = true;
      useOSProber = false;
    };
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
