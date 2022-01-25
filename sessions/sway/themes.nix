{ config, pkgs, ... }:

{
  home-manager.users.tyd2l = { pkgs, ... }: {
     
    gtk = {
      enable = true;
      font.name = "Noto Sans";
      iconTheme.name = "Flat-Remix-Blue-Dark";
      theme.name = "Adwaita-dark";
      gtk3.extraConfig = 
      {
        gtk-xft-antialias = "1";
        gtk-xft-hinting = "1";
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-application-prefer-dark-theme = "1";
      };
  };
  
#    qt = {
#      enable = true;
#      platformTheme = "gtk";
#      style = "adwaita-dark";
#    };
  };
  programs.qt5ct.enable = true;
#  qt5 = {
#      enable = true;
#      platformTheme = "gnome";
#      style = "adwaita-dark";
#    };
}
