{ config, pkgs, ... }:
{
  imports =
    [ 
      <home-manager/nixos>
      #../modules/gaming.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  services.xserver.libinput.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    nix-prefetch-git
    gtypist
    mtpfs
    jmtpfs
    exfatprogs
    ventoy-bin-full
    pulseaudioFull
    bluezFull
    qrcp
    glxinfo
 ## Network
    firefox-bin
    thunderbird-wayland
    kotatogram-desktop
    yandex-disk
    transmission-gtk
    protonvpn-gui
    qbittorrent
 ## Security
    bitwarden
 ## Vulkan support
    vulkan-headers
    vulkan-loader
    vulkan-extension-layer
 ## Text
    libreoffice-fresh
    simplenote
    obsidian
 ## Coding
    gcc
    clang
    pkgs.gitAndTools.gitFull
    winetricks
  ];
  
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    systemService = true;
    user = "teuwers";
    configDir = "/home/teuwers/.config/syncthing";
  };
  
#### User account

  users.users.teuwers = {
    isNormalUser = true;
    extraGroups = [ 
    "wheel"
    "sound" 
    "video" 
    "lp" 
    "pipewire"
    "syncthing"
  ]; 
    uid = 1000;
  };
  
  users.extraUsers.teuwers.shell = pkgs.zsh;
  
#### Network

#  networking.wireless.iwd.enable = true;
#  networking.wireless.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi = {
#      backend = "iwd";
      powersave = true;
    };
  };
  users.extraGroups.network-manager.members = [ "teuwers" ];
 
#### Bluetooth

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  
#### Sound

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
    home.stateVersion = "22.11";
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
      desktop = "\$HOME/.Desktop";
      documents = "\$HOME/Docs";
      download = "\$HOME/Downloads";
      music = "\$HOME/Audios";
      pictures = "\$HOME/Images";
      publicShare = "\$HOME/.Public";
      templates = "\$HOME/.Templates";
      videos = "\$HOME/Videos";
#      extraConfig = 
#        {
#           XDG_MISC_DIR = "${config.home.homeDirectory}/Misc";
#        };
    };
  };
  
#### ADB
 
  programs.adb.enable = true;
  users.extraGroups.adbusers.members = [ "teuwers" ];
  
#### GUI

  services.xserver.enable = true;
  programs.xwayland.enable = true;
  xdg.portal.enable = true;
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

#### Virtualisation
  
#  virtualisation.virtualbox.host = {
#    enable = true;
#    enableExtensionPack = true;
#  };
#  users.extraGroups.vboxusers.members = [ "teuwers" ];
#  environment.systemPackages = with pkgs; [ linuxPackages_zen.virtualbox ];
  
#  virtualisation.libvirtd.enable = true;
#  users.extraGroups.libvirtd.members = [ "teuwers" ];
}
