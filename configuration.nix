{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./machines/current.nix
    ];

#### System

  system.stateVersion = "21.11";
  services.fwupd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
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
  
#### User account

  users.users.tyd2l = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sound" "video" "lp" "networkmanager"]; 
    uid = 1000;
  };
 
#### Bluetooth

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

#### SSH
  
  services.sshd.enable = true;
  programs.ssh.startAgent = true;
  
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
    zsh-completions
    pulseaudioFull
    bluezFull
    p7zip
    handlr
    qrcp
    linuxPackages_zen.virtualbox
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
    noto-fonts-cjk
    noto-fonts-emoji
  ];

#### Console

  console = {
    earlySetup = true;
    font = "Lat2-Terminus16";
    keyMap = "ru";
  };

#### Shell

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "af-magic";
    };
  };
  
  users.extraUsers.tyd2l.shell = pkgs.fish;
  users.extraUsers.root.shell = pkgs.fish;
}
