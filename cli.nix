{ config, pkgs, ... }:

{
  imports =
    [ 
      ./base.nix
    ];
    
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
