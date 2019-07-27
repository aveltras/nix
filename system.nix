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

  swapDevices = [ ];
  
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  
  nix.binaryCaches = [
    "https://cache.nixos.org/"
    "https://nixcache.reflex-frp.org"
  ];
    
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
  ];

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
    alacritty
    cachix
    chromium
    emacs
    firefox
    git
    gnupg
    inkscape
    krita
    nixops
    pass
    vscode
  ];

  fonts = {
    fontconfig.enable = true;
    fonts = with pkgs; [
      fantasque-sans-mono
      font-awesome_5
      iosevka-bin
    ];
  };
  
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.udisks2.enable = true;
  programs.zsh.enable = true;

  services.redshift = {
    enable = true;
    latitude = "45.75";
    longitude  = "4.85";
    temperature = {
      day = 5000;
      night = 3250;
    };
  };
  
  services.xserver = {
    enable = true;
    layout = "fr";
    xkbOptions = "ctrl:nocaps";
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
  };
}
