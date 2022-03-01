{ config, pkgs, ... }:

{
  imports =
    [ 
      <home-manager/nixos>
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  environment.systemPackages = with pkgs; [
    mtpfs
    jmtpfs
    exfat
    exfatprogs
    xboxdrv
 ## Network
    brave
    thunderbird-wayland
    tdesktop
    spotify
 ## Security
    bitwarden
 ## Vulkan support
    vulkan-headers
    vulkan-loader
    vulkan-extension-layer
 ## Text
    libreoffice-fresh
    simplenote
 ## Coding
    gcc
    clang
    pkgs.gitAndTools.gitFull
  ];
  
#### User account

  users.users.tyd2l = {
    isNormalUser = true;
    extraGroups = [ 
    "wheel" 
    "sound" 
    "video" 
    "lp" 
  ]; 
    uid = 1000;
  };
  
  users.extraUsers.tyd2l.shell = pkgs.fish;
 
#### Bluetooth

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  
#### Sound

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
 
#### Printing

  services.printing = {
    enable = true;
    drivers = with pkgs; [ samsungUnifiedLinuxDriver hplip gutenprint canon-cups-ufr2 ];
  };
  
#### Progs configs

  home-manager.useGlobalPkgs = true;

  home-manager.users.tyd2l = { pkgs, ... }: {
  
    programs.git = {
      enable = true;
      userName  = "tyd2l";
      userEmail = "tyd2l@posteo.net";
      extraConfig = {
        credential.helper = "cache --timeout=36000";
      };
    };
  };
 
  programs.adb.enable = true;
  users.extraGroups.adbusers.members = [ "tyd2l" ];
  
#### GUI
  
  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
  };
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  
  programs.xwayland.enable = true;
  
#### Virtualisation
  
#  virtualisation.virtualbox.host = {
#    enable = true;
#    enableExtensionPack = true;
#  };
#  users.extraGroups.vboxusers.members = [ "tyd2l" ];
  
#  virtualisation.libvirtd.enable = true;
#  users.extraGroups.libvirtd.members = [ "tyd2l" ];

}
