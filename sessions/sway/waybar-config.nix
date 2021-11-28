{ config, pkgs, ... }:

{
  imports = [ ./waybar-css.nix ];
  
  home-manager.users.tyd2l = { pkgs, ... }: {
  
    programs.waybar = {
    enable = true;
    settings = 
    [
      {
         layer = "top";
         position = "top";
         height = 30;
         modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
         modules-right = [ "sway/language" "backlight" "battery" "network" "bluetooth" "pulseaudio" "tray" "clock" "custom/shutdown" ]; 
             
         modules = {    
             "sway/workspaces" = {
                 disable-scroll = true;
                 all-outputs = true;
                 format = "{icon}";
                # format-icons = {
         		#   3 = "3";
	         	#   4 = "4";
         		#   5 = "5";
         		#   6 = "6";
	            #   7 = "7";
         		#   8 = "8";
	         	#   9 = "9";
         		#   10 = "10";
                # };
             };
             
             "sway/mode" = {
                 format = "<span style=\"italic\">{}</span>";
             };
             
             "sway/window" = {
                 format = "{}";
             };
             
             "tray" = {
                 icon-size = 14;
                 spacing = 5;
             };
             
             "clock" = {
                 tooltip-format = "{:%A %B %d %Y | %H:%M}";
                 format = " {:%a %d %b %H:%M}";
                 interval = 1;
                 on-click = "exec gnome-calendar";
             };
             
             "backlight" = {
                 format = "{icon} {percent}%";
                 format-icons = [ "" ];
         	     on-click = "brightnessctl s 50%";
	             on-scroll-up = "brightnessctl s 5%+";
         	     on-scroll-down = "brightnessctl s 5%-";
             };
             
             "battery" = {
                 states = {
                     good = 95;
                     warning = 30;
                     critical = 15;
                 };
                 format = "{icon} {capacity}%";
                 format-icons = ["" "" "" "" ""];
             };
             
             "network" = {
                 interface = "wlan0";
                 format-wifi = " {essid}";
                 format-disconnected = "⚠ Disconnected";
                 on-click = "iwgtk";
             };
             
             "pulseaudio" = {
                 scroll-step = 5;
                 format = "{icon} {volume}%";
                 format-bluetooth = "{icon} {volume}%";
                 format-muted = "muted";
                 format-icons = {
                     headphones = "";
                     handsfree = "";
                     headset = "";
                     phone = "";
                     portable = "";
                     car = "";
                     default = ["" ""];
                 };
                 on-click = "pavucontrol";
             };
             
            "custom/shutdown" = {
         	    format = " ⏻ ";
         	    on-click = "exec wlogout";
             };
             
            "bluetooth" = {
           	    format = "{icon}";
           	    format-icons = {
           		    enabled = " On ";
           		    disabled = " Off ";
           	    };
           	    tooltip-format = "{}";
           	    on-click = "connman-gtk";
            };
         };
        }
      ];
    };
  };  
} 
