host:
{ config, lib, pkgs, ... }:

let
  homeManagerThunk = builtins.fromJSON (builtins.readFile /etc/nixos/home-manager.json);
in
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    "${./.}/hosts/${host}.nix"
    "${builtins.fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/${homeManagerThunk.rev}.tar.gz";
      sha256 = homeManagerThunk.sha256;
    }}/nixos"
  ];

  system.stateVersion = "19.09";
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.shellAliases = {
    "update-nix" = "sudo -- sh -c 'nix-prefetch-git https://github.com/aveltras/nix > /etc/nixos/nix.json; nix-prefetch-git https://github.com/rycee/home-manager > /etc/nixos/home-manager.json'";
  };
  
  home-manager.users.romain = import ./home;
  users.users.romain = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
  };
  
  networking.networkmanager = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/issues/61490
    extraConfig = ''
      [main]
      rc-manager=resolvconf
    '';
  };

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "fr_FR.UTF-8/UTF-8" ];
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    alacritty
    dmenu
    emacs
    firefox
    git
    gotop
    inkscape
    krita
    #xorg.xbacklight
    nix-prefetch-git
    rofi
    rxvt_unicode
    haskellPackages.xmobar
  ];

  fonts.fonts = with pkgs; [
    fantasque-sans-mono
    font-awesome
    iosevka-bin
  ];

  sound.enable = true;
  #sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;

  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [

      # Lower Brightness
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 5"; }

      # Increase Brightness
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 5"; }

      # "Mute" media key
      # { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/pactl set-sink-mute 0 toggle"; }

      # "Lower Volume" media key
      # { keys = [ 114 ]; events = [ "key" "rep" ]; command = "/run/current-system/sw/bin/pactl set-sink-volume 0 +3%"; }

      # "Raise Volume" media key
      # { keys = [ 115 ]; events = [ "key" "rep" ]; command = "/run/current-system/sw/bin/pactl set-sink-volume 0 +3%"; }

    ];
  };
  
  services.xserver = {
    desktopManager.xterm.enable = false;
    enable = true;
    layout = "fr";
    xkbOptions = "ctrl:nocaps";
    windowManager.default = "xmonad";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    displayManager.slim = {
      enable = true;
      defaultUser = "romain";
    };
    /*desktopManager.gnome3.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };*/
  };
  
  /*environment.gnome3.excludePackages = with pkgs.gnome3; (lib.lists.subtractLists [
    gnome-terminal
    gnome-tweaks
    nautilus
  ] optionalPackages);

  services.gnome3 = {
    evolution-data-server.enable = lib.mkForce false;
    gnome-disks.enable = lib.mkForce false;
    gnome-documents.enable = lib.mkForce false;
    # gnome-keyring.enable = lib.mkForce false;
    gnome-online-accounts.enable = lib.mkForce false;
    gnome-online-miners.enable = lib.mkForce false;
    gnome-remote-desktop.enable = lib.mkForce false;
    gnome-user-share.enable = lib.mkForce false;
    gpaste.enable = lib.mkForce false;
    gvfs.enable = lib.mkForce false;
    rygel.enable = lib.mkForce false;
    seahorse.enable = lib.mkForce false;
    sushi.enable = lib.mkForce false;
    tracker.enable = lib.mkForce false;
    tracker-miners.enable = lib.mkForce false;
  };*/

  
}
