{ config, lib, pkgs, ... }:

let
  homeManagerThunk = builtins.fromJSON (builtins.readFile ./home-manager.json);
in
{
  imports = [
    "${builtins.fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/${homeManagerThunk.rev}.tar.gz";
      sha256 = homeManagerThunk.sha256;
    }}/nixos"
  ];

  system.stateVersion = "19.09";

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home-manager.users.romain = import ./home.nix;
  
  users.users.romain = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    shell = pkgs.zsh;
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
    supportedLocales = [ "fr_FR.UTF-8/UTF-8" ];
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    cachix
    chromium
    emacs
    firefox
    git
    inkscape
    krita
    nixops
  ];

  fonts = {
    fontconfig.enable = true;
    fonts = with pkgs; [
      fantasque-sans-mono
      iosevka-bin
    ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.udisks2.enable = true;
  programs.zsh.enable = true;

  services.xserver = {
    enable = true;
    layout = "fr";
    xkbOptions = "ctrl:nocaps";
    desktopManager.gnome3.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };
  };

  environment.gnome3.excludePackages = with pkgs.gnome3; (lib.lists.subtractLists [
    gnome-terminal
    gnome-tweaks
    nautilus
  ] optionalPackages);

  services.gnome3 = {
    evolution-data-server.enable = lib.mkForce false;
    gnome-disks.enable = lib.mkForce false;
    gnome-documents.enable = lib.mkForce false;
    gnome-keyring.enable = lib.mkForce false;
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
  };
}
