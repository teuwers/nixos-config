{ config, pkgs, stdenv, fetchFromGitHub, ... }:

{
  users.extraGroups.sway.members = [ "tyd2l" ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
  ### Apps
      #kitty
      foot
      libsForQt5.okular
      libsForQt5.kdialog
      qbittorrent
      ghostwriter
      font-manager
      skanlite
      krita
      mpv
      pcmanfm-qt
      lxqt.lxqt-archiver
      lxqt.lxqt-sudo
      lxqt.qps
      lxqt.lximage-qt
      lxqt.pavucontrol-qt
      gtypist
      klavaro
      libsForQt5.kcalc
      cudatext-gtk
  ### Environment packages
      swaylock-effects
      swayidle
      xwayland
      wl-clipboard
      mako
      waybar
      rofi-wayland
      rofi-power-menu
      rofi-calc
#      rofi-file-browser
      grim
      slurp
      wlogout
      wl-clipboard
      brightnessctl
      gthumb
      imagemagick
      glib
      networkmanager_dmenu
      bluez
      bluez-tools
      bluez-alsa
      nix-prefetch-git
      libsecret
      libsForQt5.qt5.qtgraphicaleffects
      polkit
      polkit_gnome
      workstyle
      line-awesome
  ### Interface
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      gnome-themes-standard
      adwaita-qt
      flat-remix-icon-theme
#      capitaine-cursors
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export MOZ_ENABLE_WAYLAND=1
#      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
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
    
    xdg.configFile."sway".source = ../dot_config/sway;
    xdg.configFile."rofi".source = ../dot_config/rofi;
#    xdg.configFile."kitty.source = ../dot_config/kitty;
    xdg.configFile."foot".source = ../dot_config/foot;
    xdg.configFile."mako".source = ../dot_config/mako;
    xdg.configFile."waybar".source = ../dot_config/waybar;
    xdg.configFile."qt5ct".source = ../dot_config/qt5ct;
    xdg.configFile."mpv".source = ../dot_config/mpv;
    xdg.configFile."ghostwriter".source = ../dot_config/ghostwriter;
    xdg.configFile."pcmanfm-qt".source = ../dot_config/pcmanfm-qt;
    xdg.configFile."cudatext/settings/user.json".source = ../dot_config/cudatext/settings/user.json;
    xdg.configFile."lximage-qt".source = ../dot_config/lximage-qt;
    xdg.configFile."QtProject.conf".source = ../dot_config/QtProject.conf;
    
    home.packages = [
      (pkgs.writeShellScriptBin "dmenu" ''
      exec ${pkgs.rofi}/bin/rofi -dmenu "$@"
      '')
      (pkgs.writeShellScriptBin "xterm" ''
      exec ${pkgs.foot}/bin/foot "$@"
      '')
    ];
    
    xsession = {
      enable = true;
#      pointerCursor = {
#        size = 40;
#        package = pkgs.capitaine-cursors;
#        name = "capitaine-cursors-white";
#      };
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
#        gtk-cursor-theme-name = "capitaine-cursors-white";
        gtk-application-prefer-dark-theme = "1";
      };
      gtk4.extraConfig = 
      {
        gtk-xft-antialias = "1";
        gtk-xft-hinting = "1";
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
#        gtk-cursor-theme-name = "capitaine-cursors-white";
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
#    wifi.backend = "iwd";
  };
  users.extraGroups.network-manager.members = [ "tyd2l" ];
  
  services.udisks2.enable = true;
  
  programs.kdeconnect.enable = true;
  
  environment.sessionVariables = 
  {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    SHELL = "{pkgs.fish}/bin/fish";
#    XCURSOR_THEME = "capitaine-cursors-white";
    TERM = "foot";
  };
#  environment.systemPackages = with pkgs; [ polkit_gnome ];
  environment.pathsToLink = [ "/libexec" ];
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  
  # Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
  environment.systemPackages = with pkgs; [
    (
      pkgs.writeTextFile {
        name = "startsway";
        destination = "/bin/startsway";
        executable = true;
        text = ''
          #! ${pkgs.bash}/bin/fish

          # first import environment variables from the login manager
          systemctl --user import-environment
          # then start the service
          exec systemctl --user start sway.service
        '';
      }
    )
  ];

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.displayManager.defaultSession = "sway";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.enableHidpi = true;
  services.xserver.displayManager.sddm.theme = "${(pkgs.fetchFromGitHub {
    owner = "RadRussianRus";
    repo = "sddm-slice";
    rev = "1ddbc490a500bdd938a797e72a480f535191b45e";
    sha256 = "0b2ga0f4z61h7hfip2clfqdvr6friix1a8q6laiklfq7d4rm236l";
  })}";

#  services.greetd.enable = true;
#  services.greetd.settings = 
#  {
#    default_session = {
#      command = "${pkgs.greetd.greetd}/bin/agreety --cmd sway";
#    };
#  };  
  
  security.polkit.enable = true;
} 
