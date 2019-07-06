{ config, pkgs, ... }:

let
  iconTheme = builtins.fetchTarball {
    url = "https://github.com/vinceliuice/Tela-icon-theme/archive/2019_06_28.tar.gz"; 
    sha256 = "0p7fac2hg44sdpw7g2hdfivs0j1b350v9gplajzddd770qn4yba8";
  };
in
{
  home.file.".background-image".source = ./assets/images/W_2014_351_SOFTBOX_III.jpg;
  home.file.".config/rofi/config.rasi".source = ./dotfiles/rofi/config.rasi;

  /*home.file.".local/share/icons/tela" = {
    source = "${iconTheme}/src";
    recursive = true;
  };*/

  services = {
    redshift = {
      enable = true;
      latitude = "45.75";
      longitude  = "4.85";
      temperature = {
        day = 5000;
        night = 3250;
      };
    };
    screen-locker = {
      enable = true;
      xautolockExtraOptions = [
        "-corners" "+0-0"
      ];
    };
    unclutter.enable = true;
  };
  
  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    git = {
      enable = true;
      userName = "Romain Viallard";
      userEmail = "romain.viallard@outlook.fr";
    };
  };
}
