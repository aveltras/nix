{ config, pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      userName = "Romain Viallard";
      userEmail = "romain.viallard@outlook.fr";
    };
  };
}
