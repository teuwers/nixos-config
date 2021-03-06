{ config, pkgs, ... }:

{
  imports =
    [ 
      ../target/pc.nix
	# Choose WM/DE
      ../sessions/sway.nix
      #../sessions/gnome.nix
      #../sessions/plasma.nix
    ];

  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  time.hardwareClockInLocalTime = true;
  
  hardware.opengl.extraPackages = with pkgs; [
   rocm-opencl-icd
   rocm-opencl-runtime
   amdvlk
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
  
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  
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
      extraEntries = ''
        menuentry "Windows" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root 383A-1A55
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
    };
  };
  
#### Network

  networking = {
    hostName = "mike-desktop";
    interfaces.wlan0.useDHCP = true;
    };

  #nixpkgs.config.packageOverrides = pkgs: {
  #  steam = pkgs.steam.override {
  #    nativeOnly = true;
  #  };
  #};
  programs.steam.enable = true;
}
