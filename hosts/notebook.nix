{ config, pkgs, ... }:

{
  imports =
    [ 
      ../configuration.nix
      ./notebook-hardware.nix
      ../target/pc.nix
	# Choose WM/DE
      #../sessions/gnome.nix
      ../sessions/plasma.nix
    ];

  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  powerManagement.enable = true;
  
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
      efiSupport = true;
      enableCryptodisk = true;
      useOSProber = true;
    };
  };
  time.hardwareClockInLocalTime = true;

#### Network

  networking = {
    hostName = "mike-notebook";
    interfaces.enp1s0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
  };

#### OpenGL drivers

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
}
