{ config, pkgs, ... }:

{
  home-manager.users.tyd2l = { pkgs, ... }: {
     
    gtk = {
      enable = true;
      font.name = "Noto Sans";
      iconTheme.name = "Flat-Remix-Blue-Dark";
      theme.name = "Adwaita-dark";
      gtk2.extraConfig = 
      {
        gtk-xft-antialias = "1";
        gtk-xft-hinting = "1";
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-cursor-theme-name = "PointingHand-White";
        gtk-application-prefer-dark-theme = "1";
      };
      gtk3.extraConfig = 
      {
        gtk-xft-antialias = "1";
        gtk-xft-hinting = "1";
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-cursor-theme-name = "PointingHand-White";
        gtk-application-prefer-dark-theme = "1";
      };
      gtk4.extraConfig = 
      {
        gtk-xft-antialias = "1";
        gtk-xft-hinting = "1";
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-cursor-theme-name = "PointingHand-White";
        gtk-application-prefer-dark-theme = "1";
      };
    };
  };
}
