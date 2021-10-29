{ config, pkgs, ... }:

{
  imports =
    [ 
       ./sway-environment.nix
       ./waybar-config.nix
	   ./themes.nix
    ];
  
  users.users.tyd2l.extraGroups = [ "sway" ];

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
      connmanFull
      connman-gtk
      connman-notify
  ### Interface
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      gnome-themes-standard
      adwaita-qt
	  flat-remix-icon-theme
      capitaine-cursors
    ];
  };
  
#### Apps config

  home-manager.users.tyd2l = { pkgs, ... }: {
    xdg.configFile."sway/config".source = ../dot_config/sway/config;
    xdg.configFile."rofi/config.rasi".source = ../dot_config/rofi/config.rasi;
	xdg.configFile."rofi/themes/oxide.rasi".source = ../dot_config/rofi/themes/oxide.rasi;
    xdg.configFile."kitty/config".source = ../dot_config/kitty/kitty.conf;
    xdg.configFile."mako/config".source = ../dot_config/mako/config;
  };

#### Environment config

  xdg.portal = {
    extraPortals = with pkgs; 
    [ xdg-desktop-portal 
      xdg-desktop-portal-wlr 
      xdg-desktop-portal-gtk ]; 
    gtkUsePortal = true;
  };
  
  services.connman = {
    enable = true;
    backend = "iwd";
    networkInterfaceBlacklist = [ ];
    extraConfig = "[General]\nAllowHostnameUpdates=false"; 
  };
  
  environment.systemPackages = with pkgs; [ polkit_gnome ];
  environment.pathsToLink = [ "/libexec" ];
  programs.dconf.enable = true;
  services.gvfs.enable = true;
} 
