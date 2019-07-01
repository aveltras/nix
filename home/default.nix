{ config, pkgs, ... }:

{
  home.file.".background-image".source = ./wallpapers/mountains-on-mars.png;

  dconf.settings = {
    "org/gnome/desktop/background" = {
      "picture-uri" = "file:///home/romain/.background-image";
    };
  };
  
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Romain Viallard";
      userEmail = "romain.viallard@outlook.fr";
    };
  };
}
