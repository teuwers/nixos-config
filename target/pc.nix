{ config, pkgs, ... }:

{
  imports =
    [ 
      <home-manager/nixos>
    ];

  environment.systemPackages = with pkgs; [
    libnotify
    mtpfs
    jmtpfs
    exfat
    exfatprogs
    xboxdrv
 ## Network
    firefox-wayland
    thunderbird-wayland
    tdesktop
    spotify
 ## Security
    bitwarden
 ## Vulkan support
    vulkan-headers
    vulkan-loader
   # vulkan-extension-layer
 ## Text
    libreoffice-fresh
    simplenote
 ## Coding
    gcc
    clang
    pkgs.gitAndTools.gitFull
  ];
  
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
