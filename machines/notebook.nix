{ config, pkgs, ... }:

{
  imports =
    [ 
      ../target/pc.nix
	# Choose WM/DE
      #../sessions/sway.nix
      #../sessions/sway-notebook.nix
      ../sessions/gnome.nix
      #../sessions/plasma.nix
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
      version = 2;
      efiSupport = true;
      enableCryptodisk = true;
      useOSProber = true;
#      trustedBoot.enable = true;
      trustedBoot.systemHasTPM = "YES_TPM_is_activated";
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
  
#### MPV config
  
  home-manager.users.teuwers = { pkgs, ... }: {
    home.packages = [
      (pkgs.writeShellScriptBin "mpv" ''
      exec ${pkgs.mpv}/bin/mpv --profile=M60 "$@"
      '')
    ];
  };
}
