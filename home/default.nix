{ config, pkgs, ... }:

{
  home.file.".background-image".source = ./wallpapers/mountains-on-mars.png;

  /*dconf.settings = {
    "org/gnome/desktop/background" = {
      "picture-uri" = "file:///home/romain/.background-image";
    };
  };*/

/*  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.writeText "xmonad.hs" ''
        import XMonad
        main = xmonad def { modMask = mod4Mask, terminal = "alacritty" }
      '';
    };
  };*/

  services.redshift = {
    enable = true;
    latitude = "45.75";
    longitude  = "4.85";
    temperature = {
      day = 5000;
      night = 3250;
    };
  };
  
  programs = {
    home-manager.enable = true;
    #alacritty.enable = true;
    fish.enable = true;
    git = {
      enable = true;
      userName = "Romain Viallard";
      userEmail = "romain.viallard@outlook.fr";
    };
  };
}
