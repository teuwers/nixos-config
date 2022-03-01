{ config, pkgs, ... }:

{
  imports =
    [ 
      <home-manager/nixos>
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  environment.systemPackages = with pkgs; [
    mtpfs
    jmtpfs
    exfat
    exfatprogs
    pkgs.gitAndTools.gitFull
  ];
  
#### User account

  users.users.mdwrr = {
    isNormalUser = true;
    extraGroups = [ 
    "wheel" 
    "sound" 
    "video" 
    "lp" 
  ]; 
    uid = 1000;
  };
  
  users.extraUsers.mdwrr.shell = pkgs.fish;

#### Progs configs

  home-manager.useGlobalPkgs = true;

  home-manager.users.mdwrr = { pkgs, ... }: {
  
    programs.git = {
      enable = true;
      userName  = "tyd2l";
      userEmail = "tyd2l@posteo.net";
      extraConfig = {
        credential.helper = "cache --timeout=36000";
      };
    };
  };
  
#### Virtualisation
  
#  virtualisation.virtualbox.host = {
#    enable = true;
#    enableExtensionPack = true;
#  };
#  users.extraGroups.vboxusers.members = [ "tyd2l" ];
  
#  virtualisation.libvirtd.enable = true;
#  users.extraGroups.libvirtd.members = [ "tyd2l" ];

}
