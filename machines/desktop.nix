{ config, pkgs, ... }:

{
  imports =
    [ 
	# Choose WM/DE
      ../sessions/sway/sway.nix
      #../sessions/gnome.nix
    ];

  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  hardware.opengl.extraPackages = with pkgs; [
   rocm-opencl-icd
   rocm-opencl-runtime
   amdvlk
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  
#### Bootloader
    
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    version = 2;
    efiSupport = true;
	timeout = 30;
  };
  
#### Network

  networking = {
    hostName = "mike-desktop";
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