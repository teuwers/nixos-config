{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./machines/current.nix
    ];

#### System

  system.stateVersion = "22.11";
  services.fwupd.enable = true;
  nixpkgs.config.allowUnfree = true;
  
#### Remove old generations

  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";
  
#### Autoupgrade

  system.autoUpgrade.enable = true; 

#### Timezone and locale

  time.timeZone = "Europe/Moscow";
  i18n = {
    glibcLocales = pkgs.glibcLocales;
    defaultLocale = "ru_RU.UTF-8";
    supportedLocales = 
    [  "ru_RU.UTF-8/UTF-8"
       "en_US.UTF-8/UTF-8"
    ];
  };
  
  services.ntp.enable = true;
  
#### SSH
  
  services.sshd.enable = true;
  programs.ssh.startAgent = true;
  
#### TRIM

  services.fstrim.enable = true;
  
#### ZRAM
  
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
  
#### Packages

  environment.systemPackages = with pkgs; [
    git
    rsync
    wget
    neofetch
    htop
    killall
    powerline
    p7zip
    handlr
    qrcp
    mime-types
    shared-mime-info
    unrar
    parted
  ];
  
#### Fonts

  fonts.fonts = with pkgs; [
    liberation_ttf
    line-awesome
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk
    noto-fonts-emoji
  ];

#### Console

  console = {
    earlySetup = true;
    font = "Lat2-Terminus16";
    keyMap = "ru";
  };

  users.extraUsers.root.shell = pkgs.fish;
}
