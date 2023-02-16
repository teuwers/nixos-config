{ config, pkgs, lib, stdenv, fetchFromGitHub, ... }:

let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
  dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
  systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Adwaita-dark'
        '';
  };
  
in
{
  imports =
    [ 
      #sway/xcursor-theme.nix
    ];

  users.extraGroups.sway.members = [ "teuwers" ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
  ### Apps
      alacritty
      libsForQt5.okular
      libsForQt5.kdialog
      qbittorrent
      ghostwriter
      font-manager
      skanlite
      krita
      mpv
      lxqt.qps
      lxqt.lximage-qt
      lxqt.pavucontrol-qt
      gtypist
      klavaro
      libsForQt5.kcalc
      gnome.gedit
      pcmanfm
      xarchiver
      celluloid
  ### Environment packages
      configure-gtk
      dbus-sway-environment
      swaylock-effects
      swayidle
      xwayland
      wl-clipboard
      waybar
      rofi-wayland
      rofi-power-menu
      grim
      slurp
      wlogout
      wl-clipboard
      gthumb
      imagemagick
      glib
      networkmanager_dmenu
      bluez
      bluez-tools
      bluez-alsa
      libsecret
      libsForQt5.qt5.qtgraphicaleffects
      swaywsr
      swaykbdd
      libappindicator
      dunst
      wob
      playerctl
      xorg.xev
      wev
  ### Interface
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      gnome-themes-extra
      adwaita-qt
      flat-remix-icon-theme
    ];
    extraSessionCommands = ''
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };
  
  environment.variables = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland";
  };
  
#### Apps config

  home-manager.users.teuwers = { pkgs, ... }: {
    xdg.configFile."sway".source = ../dot_config/sway;
    xdg.configFile."rofi".source = ../dot_config/rofi;
    xdg.configFile."dunst".source = ../dot_config/dunst;
    xdg.configFile."swaywsr".source = ../dot_config/swaywsr;
    xdg.configFile."waybar".source = ../dot_config/waybar;
    xdg.configFile."ghostwriter".source = ../dot_config/ghostwriter;
    xdg.configFile."pcmanfm-qt".source = ../dot_config/pcmanfm-qt;
    xdg.configFile."lximage-qt".source = ../dot_config/lximage-qt;
    xdg.configFile."QtProject.conf".source = ../dot_config/QtProject.conf;
    
    home.packages = [
      (pkgs.writeShellScriptBin "dmenu" ''
      exec ${pkgs.rofi}/bin/rofi -dmenu "$@"
      '')
      (pkgs.writeShellScriptBin "xterm" ''
      exec ${pkgs.alacritty}/bin/alacritty "$@"
      '')
    ];
  };
  
  qt5.enable = true;
  qt5.style = "adwaita-dark";
  qt5.platformTheme = "gnome";
  
#### Environment config

  xdg.portal.wlr.enable = true;
  services.udisks2.enable = true;
  programs.kdeconnect.enable = true;
  environment.pathsToLink = [ "/libexec" ];
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  programs.light.enable = true;
  hardware.acpilight.enable = true;
  services.dbus.enable = true;

  services.greetd.enable = true;
  services.greetd.package = pkgs.greetd.wlgreet;
  

} 
