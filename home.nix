{ config, lib, pkgs, ... }:

let
  iconTheme = builtins.fetchTarball {
    url = "https://github.com/vinceliuice/Tela-icon-theme/archive/2019_06_28.tar.gz"; 
    sha256 = "0p7fac2hg44sdpw7g2hdfivs0j1b350v9gplajzddd770qn4yba8";
  };
  exo2 = pkgs.fetchsvn {
    url = "https://github.com/google/fonts/trunk/ofl/exo2";
    sha256 = "1afi3f6dj0qdzfzw1xwb0adq1cnrwqf8x4zs9h1zvdixf457vg8l";
  };
  capitaineCursors = pkgs.fetchsvn {
    url = "https://github.com/keeferrourke/capitaine-cursors/trunk/dist";
    sha256 = "0ppy7mm5s6qx7j5md0x9fibwgyza4mi2pgnk1hqnzkd7cvhqbs24";
  };
in
{
  home.file.".local/share/fonts/exo2" = {
    source = "${exo2}";
    recursive = true;
  };

  home.file.".icons/default/" = {
    source = capitaineCursors;
    recursive = true;
  };

  home.file.".config/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-cursor-theme-name=Capitaine Cursors
    gtk-application-prefer-dark-theme=0
    gtk-icon-theme-name=Adwaita
    gtk-theme-name=Breeze
    gtk-font-name=Sans Serif Regular 10
    gtk-cursor-theme-size=0
    gtk-toolbar-style=GTK_TOOLBAR_ICONS
    gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
    gtk-button-images=1
    gtk-menu-images=1
    gtk-enable-event-sounds=1
    gtk-enable-input-feedback-sounds=1
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintslight
    gtk-xft-rgba=rgb
  '';

  home.keyboard.layout = "fr";

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      stdlib = pkgs.lib.fileContents ./dotfiles/direnvrc;
    };
    git = {
      enable = true;
      userName = "Romain Viallard";
      userEmail = "romain.viallard@outlook.fr";
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "sorin";
      };
    };
  };
}
