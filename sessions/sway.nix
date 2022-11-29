{ config, pkgs, stdenv, fetchFromGitHub, ... }:

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
      foot
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
      cudatext-gtk
      pcmanfm
      xarchiver
      celluloid
  ### Environment packages
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
#      capitaine-cursors
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
    xdg.configFile."foot".source = ../dot_config/foot;
    xdg.configFile."dunst".source = ../dot_config/dunst;
    xdg.configFile."swaywsr".source = ../dot_config/swaywsr;
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
    
 #   xsession = {
 #     enable = true;
#      pointerCursor = {
#        size = 40;
#        package = pkgs.capitaine-cursors;
#        name = "capitaine-cursors-white";
#      };
 #   };
    
    gtk = {
      enable = true;
      font.name = "Noto Sans";
      iconTheme.name = "Flat-Remix-Blue-Dark";
      theme.name = "Adwaita-dark";
      gtk3.bookmarks = 
        [ 
          "file:///home/teuwers/Audios"
          "file:///home/teuwers/Docs"
          "file:///home/teuwers/Downloads"
          "file:///home/teuwers/Images"
          "file:///home/teuwers/Videos"
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

  xdg.portal.wlr.enable = true;
  
  services.udisks2.enable = true;
  
  programs.kdeconnect.enable = true;
  
  environment.sessionVariables = 
  {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    SHELL = "{pkgs.fish}/bin/fish";
#    XCURSOR_THEME = "capitaine-cursors-white";
    TERM = "foot";
  };

  environment.pathsToLink = [ "/libexec" ];
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;
  programs.light.enable = true;
  hardware.acpilight.enable = true;
  
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
#      command = "${pkgs.greetd.wlgreet}/bin/wlgreet --cmd sway";
#    };
#  };  
  

} 
