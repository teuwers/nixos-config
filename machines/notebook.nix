{ config, pkgs, ... }:

{
  imports =
    [ 
      ../target/pc.nix
	# Choose WM/DE
      ../sessions/sway.nix
      ../sessions/sway-notebook.nix
      #../sessions/gnome.nix
      #../sessions/plasma.nix
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
      useOSProber = true;
    };
  };

#### Network

  networking = {
    hostName = "mike-notebook";
    interfaces.enp1s0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    wireless.iwd.enable = true;
    };

#### OpenGL drivers

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
  
  powerManagement.enable = true;
}
