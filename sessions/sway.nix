{ config, pkgs, ... }:

{
  users.extraGroups.sway.members = [ "tyd2l" ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
  ### Apps
      kitty
      evince
      gnome.gnome-calendar
      gnome.nautilus
      gnome.file-roller
      gnome.gedit
      gnome.eog
      gnome.zenity
      gnome.simple-scan
      gnome.gnome-contacts
      gnome.gnome-system-monitor
      celluloid
      gnome.gnome-disk-utility
      gparted
      gnome.gnome-keyring
      gnome.seahorse
      transmission-gtk
      apostrophe
      font-manager
      gimp-with-plugins
      gnome-online-accounts
      mpv
  ### Environment packages
      swaylock	
      swayidle
      xwayland
      wl-clipboard
      mako
      waybar
      rofi
      grim
      slurp
      wlogout
      wl-clipboard
      brightnessctl
      gthumb
      imagemagick
      pavucontrol
      glib
      evolution-data-server
      networkmanager_dmenu
      bluez
      bluez-tools
      bluez-alsa
  ### Interface
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      gnome-themes-standard
      adwaita-qt
      flat-remix-icon-theme
      capitaine-cursors
      rofi-power-menu
    ];
  };
  
#### Apps config

  home-manager.users.tyd2l = { pkgs, ... }: {
  
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
    
    xdg.configFile."sway/config".source = ../dot_config/sway/config;
    xdg.configFile."rofi/config.rasi".source = ../dot_config/rofi/config.rasi;
    xdg.configFile."rofi/themes/oxide.rasi".source = ../dot_config/rofi/themes/oxide.rasi;
    xdg.configFile."kitty/kitty.conf".source = ../dot_config/kitty/kitty.conf;
    xdg.configFile."mako/config".source = ../dot_config/mako/config;
    xdg.configFile."waybar/config".source = ../dot_config/waybar/config;
    xdg.configFile."waybar/style.css".source = ../dot_config/waybar/style.css;
    xdg.configFile."qt5ct/qt5ct.conf".source = ../dot_config/qt5ct/qt5ct.conf;
    xdg.configFile."mpv".source = ../dot_config/mpv;
    
    home.packages = [
      (pkgs.writeShellScriptBin "dmenu" ''
      exec ${pkgs.rofi}/bin/rofi -dmenu "$@"
      '')
      (pkgs.writeShellScriptBin "xterm" ''
      exec ${pkgs.kitty}/bin/kitty "$@"
      '')
    ];
    
    xsession = {
      enable = true;
      pointerCursor = {
        size = 40;
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors-white";
      };
    };
    
    gtk = {
      enable = true;
      font.name = "Noto Sans";
      iconTheme.name = "Flat-Remix-Blue-Dark";
      theme.name = "Adwaita-dark";
      gtk3.bookmarks = 
        [ 
          "file:///home/tyd2l/Audios"
          "file:///home/tyd2l/Docs"
          "file:///home/tyd2l/Downloads"
          "file:///home/tyd2l/Images"
          "file:///home/tyd2l/Videos"
          "file:///etc/nixos"
        ];  
      gtk3.extraConfig = 
      {
        gtk-xft-antialias = "1";
        gtk-xft-hinting = "1";
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-cursor-theme-name = "capitaine-cursors-white";
        gtk-application-prefer-dark-theme = "1";
      };
      gtk4.extraConfig = 
      {
        gtk-xft-antialias = "1";
        gtk-xft-hinting = "1";
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-cursor-theme-name = "capitaine-cursors-white";
        gtk-application-prefer-dark-theme = "1";
      };
    };
  };
  
  programs.qt5ct.enable = true;
  
#### Environment config

  xdg.portal = {
    extraPortals = with pkgs; 
    [ xdg-desktop-portal 
      xdg-desktop-portal-wlr 
      xdg-desktop-portal-gtk ]; 
    gtkUsePortal = true;
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  users.extraGroups.network-manager.members = [ "tyd2l" ];
  
  services.udisks2.enable = true;
  
  programs.kdeconnect.enable = true;
  
  environment.sessionVariables = 
  {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    XCURSOR_THEME = "capitaine-cursors-white";
  };
  environment.systemPackages = with pkgs; [ polkit_gnome ];
  environment.pathsToLink = [ "/libexec" ];
  programs.dconf.enable = true;
  services.gvfs.enable = true;
} 
