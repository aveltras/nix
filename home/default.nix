{ config, pkgs, ... }:

{
  home.file.".background-image".source = ./wallpapers/mountains-on-mars.png;
  
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Romain Viallard";
      userEmail = "romain.viallard@outlook.fr";
    };
  };
}
