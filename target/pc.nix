{ config, pkgs, ... }:

{
  imports =
    [ 
      <home-manager/nixos>
    ];

  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  services.xserver.libinput.enable = true;
  security.polkit.enable = true;

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

  users.users.teuwers = {
    isNormalUser = true;
    extraGroups = [ 
    "wheel" 
    "sound" 
    "video" 
    "lp" 
    "pipiwire"
  ]; 
    uid = 1000;
  };
  
  users.extraUsers.teuwers.shell = pkgs.fish;
 
#### Bluetooth

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  
#### Sound

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
 
#### Printing

  services.printing = {
    enable = true;
    drivers = with pkgs; [ samsung-unified-linux-driver hplip gutenprint canon-cups-ufr2 ];
  };
  
#### Progs configs

  home-manager.useGlobalPkgs = true;
  home-manager.users.teuwers = { pkgs, ... }: {
    home.stateVersion = "22.05";
    programs.git = {
      enable = true;
      userName  = "teuwers";
      userEmail = "lrd2wers@yandex.ru";
      extraConfig = {
        credential.helper = "cache --timeout=36000";
      };
    };
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "\$HOME/Desktop";
      documents = "\$HOME/Docs";
      download = "\$HOME/Downloads";
      music = "\$HOME/Audios";
      pictures = "\$HOME/Images";
      publicShare = "\$HOME/Public";
      templates = "\$HOME/Templates";
      videos = "\$HOME/Videos";
    };
  };
 
  programs.adb.enable = true;
  users.extraGroups.adbusers.members = [ "teuwers" ];
  
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

#### Network

  networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "iwd";
      powersave = true;
    };
  };
  users.extraGroups.network-manager.members = [ "teuwers" ];
  
#### Virtualisation
  
#  virtualisation.virtualbox.host = {
#    enable = true;
#    enableExtensionPack = true;
#  };
#  users.extraGroups.vboxusers.members = [ "teuwers" ];
  
#  virtualisation.libvirtd.enable = true;
#  users.extraGroups.libvirtd.members = [ "teuwers" ];

}
