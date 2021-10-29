{ config, pkgs, ... }:

{
  home-manager.users.tyd2l = { pkgs, ... }: {
     
    programs.kitty = {
      enable = true;
      font.name = "Noto Sans Mono";
      keybindings = {
        "ctrl+Up" = "change_font_size current +1.0";
        "ctrl+Down" = "change_font_size current -1.0";
        "ctrl+c" = "copy_or_interrupt";
      };
      settings = {
        cursor_shape = "beam";
        window_padding_width = "5 10";
        enable_audio_bell = "no";
        background = "#202020";
        background_opacity = "0.9";
        color0 = "#282a36";
        color8 = "#686868";
        color1 = "#ff5c57";
        color9 = "#ff5c57";
        color2 = "#5af78e";
        color10 = "#5af78e";
        color3 = "#f3f99d";
        color11 = "#f3f99d";
        color4 = "#57c7ff";
        color12 = "#57c7ff";
        color5 = "#ff6ac1";
        color13 = "#ff6ac1";
        color6 = "#9aedfe";
        color14 = "#9aedfe";
        color7 = "#eff0eb";
        color15 = "#f1f1f0";
        open_url_modifiers = "";
        open_url_with = "default";
      };
    };
    
    programs.mako = {
      enable = true;
      actions = true;
      anchor = "top-right";
      backgroundColor = "#202020BB";
      borderColor = "#f3f99dBB";
      borderRadius = 5;
      borderSize = 1;
      defaultTimeout = 6000;
      font = "Noto Sans";
      height = 100;
      width = 400;
      margin = "10";
      maxVisible = 5;
      padding = "5";
      textColor = "#f3f99dFF";
      extraConfig = 
       "[urgency=high]
        text-color = #ff5c57FF
        border-color = #ff5c57BB";
    };
  };
}
