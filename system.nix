{ config, lib, pkgs, ... }:

let
  homeManagerThunk = builtins.fromJSON (builtins.readFile ./home-manager.json);
  waylandOverlay = (import (builtins.fetchTarball "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz"));
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

  nixpkgs.overlays = [ waylandOverlay ];
  nixpkgs.config.allowUnfree = true;
  
  nix.binaryCaches = [
    "https://cache.nixos.org/"
    "https://nixcache.reflex-frp.org"
    "https://nixpkgs-wayland.cachix.org"
  ];
    
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
  ];

  environment.loginShellInit = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
    	exec sway
    fi
  '';
  
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
    bemenu
    cachix
    chromium
    firefox
    git
    gnupg
    inkscape
    j4-dmenu-desktop
    krita
    nixops
    pass
    weechat
  ];

  fonts = {
    fontconfig.enable = true;
    fonts = with pkgs; [
      fantasque-sans-mono
      iosevka-bin
    ];
  };

  services.redshift = {
    enable = true;
    package = pkgs.redshift-wayland;
    latitude = "45.75";
    longitude  = "4.85";
    temperature = {
      day = 5000;
      night = 3250;
    };
  };  

  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = (pkgs.emacs.overrideAttrs (attrs: {
      postInstall = (attrs.postInstall or "") + ''
        rm $out/share/applications/emacs.desktop
      '';
    }));
  };
  
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.udisks2.enable = true;
  programs.light.enable = true;
  programs.zsh.enable = true;

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      grim
      redshift-wayland
      slurp
      swaybg
      swayidle
      swaylock
      waybar
      xwayland
    ];
  };

  services.xserver.enable = false;
  
  # services.xserver = {
    # enable = true;
    # layout = "fr";
    # xkbOptions = "ctrl:nocaps";
    # desktopManager.plasma5.enable = true;
    # displayManager.sddm.enable = true;
  #   desktopManager.xterm.enable = false;
  #   windowManager = {
  #     default = "exwm";
  #     session = lib.singleton {
  #       name = "exwm";
  #       start = ''
  #         emacs --daemon -f exwm-enable
  #         emacsclient -c
  #       '';
  #     };
  #   };
  # };
}
