{ config, pkgs, ... }:

{
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
	
    gtk.gtk3.bookmarks = 
    [ 
      "file:///home/tyd2l/Audios"
      "file:///home/tyd2l/Docs"
      "file:///home/tyd2l/Downloads"
      "file:///home/tyd2l/Images"
      "file:///home/tyd2l/Videos"
      "file:///etc/nixos"
    ];  
  }; 
} 
